// hd.fingers.js — sg.landmark_detector のハンドランドマークから指先を抽出しタップを検出する
// Issue #18: ハンドトラッキング演奏パッチ (両手 10 指対応)
//
// 入力: inlet 0 — sg.landmark_detector の hand0 アウトレット (outlet 1)
//       inlet 1 — route knearest の出力 (タップで鳴ったスライス id)
//       inlet 2 — sg.landmark_detector の hand1 アウトレット (outlet 2)
//       対応フォーマット (inlet 0/2 共通):
//         - フラットリスト 21×3 (63) / 21×2 (42) 要素
//         - hand_id 付きリスト 1+63 (64) / 1+42 (43) 要素
//         - "hand <id> <conf>" メタデータ (無視)
//         - "landmark <index> <x> <y> <z>" 逐次メッセージ (index 20 でフレーム確定)
//       座標は正規化済み。y は 0=上端, 1=下端 (画面座標系)
// 出力: outlet 0 — タップ検出時に [x y] (正規化 0-1, kdtree クエリ用)
//       outlet 1 — 毎フレーム [指番号 x y] (指番号 0-4=hand0, 5-9=hand1)
//       outlet 2 — fluid.plotter 用メッセージ (setpoint/pointcolor/pointsize)

inlets = 3;
outlets = 3;

// MediaPipe 準拠の指先インデックス: 親指, 人差し指, 中指, 薬指, 小指
var TIPS = [4, 8, 12, 16, 20];
// 各指の第2関節 (親指は IP、他は PIP)。伸展判定に使う
var PIPS = [3, 6, 10, 14, 18];
var WRIST = 0;
var NFING = 10;   // 両手 10 指

// 調整パラメータ (メッセージで変更可)
var thresh = 0.035;    // 1 フレームあたりの下向き移動量しきい値 (正規化座標)
var refract = 150;     // 同一指の再発音禁止時間 (ms)
var mirror = 1;        // 1: 左右反転 (セルフィーミラー)
var flip = 1;          // 1: Y 反転。カメラは y=下向き正、fluid.plotter は y=上向き正のため既定で反転する
var dbg = 0;

// 指の伸展判定: 閉じた(折りたたんだ)指は演奏不可にする
var reqExt = 1;        // 1: 伸びている指のみタップ有効 / 0: 判定なし (メッセージ requireextended で変更)
var extRatio = 1.15;   // 指先が第2関節より extRatio 倍以上手首から遠ければ「伸びている」(extratio で変更)

// 指ごとのカーソル色
// hand0: 親指=赤, 人差し=橙, 中=緑, 薬=青, 小=紫
// hand1: 親指=黄, 人差し=シアン, 中=マゼンタ, 薬=ライム, 小=ピンク
var CURSOR_RGB = [
    [1, 0.2, 0.2], [1, 0.6, 0], [0.2, 0.8, 0.2], [0.2, 0.4, 1], [0.7, 0.3, 0.9],
    [0.95, 0.85, 0.1], [0.1, 0.85, 0.9], [0.9, 0.2, 0.9], [0.6, 0.85, 0.2], [1, 0.55, 0.75]
];
var CURSOR_MIN_MOVE = 0.012;   // これ未満の移動では setpoint を送らない (redraw 抑制。plotter が大きいと再描画が重いため強めに間引く)
var DEFAULT_RGBA = [0, 0, 0, 1];   // plotter のデフォルト点色 (黒)

var prevY, lastFire, cursorInit, lastCX, lastCY, lastHit, extState, prevExt, lastCursorAt;
var pendingFinger = -1;        // 直前にクエリを出した指 (0-9)
var fmtLogged = false;
var lmAcc = [[], []];          // "landmark <i> ..." 逐次形式の蓄積 (hand 別)

function initState() {
    prevY = []; lastFire = []; cursorInit = []; lastCX = []; lastCY = []; lastHit = [];
    extState = []; prevExt = []; lastCursorAt = [];
    for (var i = 0; i < NFING; i++) {
        prevY[i] = null; lastFire[i] = 0; cursorInit[i] = false;
        lastCX[i] = -1; lastCY[i] = -1; lastHit[i] = null; lastCursorAt[i] = 0;
        extState[i] = true; prevExt[i] = false;
    }
    pendingFinger = -1;
    fmtLogged = false;
    lmAcc = [[], []];
}
initState();

function whichHand() { return (inlet === 2) ? 1 : 0; }

function list() {
    var a = arrayfromargs(arguments);
    if (inlet === 1) { hitResult(a[0]); return; }
    parseFlat(a, whichHand());
}

function anything() {
    var a = arrayfromargs(arguments);
    if (inlet === 1) { hitResult(messagename); return; }
    var hand = whichHand();

    if (messagename === "landmark") {
        // 逐次形式: landmark <index> <x> <y> <z>
        var i = a[0];
        if (i >= 0 && i <= 20) lmAcc[hand][i] = [a[1], a[2]];
        if (i === 20) {
            var acc = lmAcc[hand];
            if (!fmtLogged) { fmtLogged = true; post("hd.fingers: 逐次 landmark 形式を検出\n"); }
            processTips(function (idx) { return acc[idx]; }, hand);
            lmAcc[hand] = [];
        }
        return;
    }
    if (messagename === "hand") {
        // "hand <id> <conf>" はメタデータ。長い場合はランドマーク列とみなす
        if (a.length >= 42) parseFlat(a, hand);
        return;
    }
    parseFlat(a, hand);
}

function msg_int(v)   { if (inlet === 1) hitResult(v); }
function msg_float(v) { if (inlet === 1) hitResult(v); }

// フラットなランドマーク列を解釈 (要素数から stride と先頭オフセットを判定)
function parseFlat(a, hand) {
    var off = 0, st = 0;
    if (a.length % 63 === 0 && a.length > 0) st = 3;
    else if (a.length % 42 === 0 && a.length > 0) st = 2;
    else if ((a.length - 1) % 63 === 0 && a.length > 1) { st = 3; off = 1; }
    else if ((a.length - 1) % 42 === 0 && a.length > 1) { st = 2; off = 1; }
    else {
        if (dbg) post("hd.fingers: 未知のリスト形式 len=" + a.length + "\n");
        return;
    }
    if (!fmtLogged) {
        fmtLogged = true;
        post("hd.fingers: stride=" + st + " offset=" + off + " (len=" + a.length + ")\n");
    }
    processTips(function (idx) {
        var b = off + idx * st;
        return (b + 1 < a.length) ? [a[b], a[b + 1]] : null;
    }, hand);
}

// 2点間の距離の2乗
function dist2(a, b) {
    var dx = a[0] - b[0], dy = a[1] - b[1];
    return dx * dx + dy * dy;
}

// 片手分の指先 5 点を処理: カーソル描画 + タップ検出。hand=0 → 指 0-4, hand=1 → 指 5-9
function processTips(get, hand) {
    var now = new Date().getTime();
    var base = hand * 5;
    var wrist = get(WRIST);
    for (var f = 0; f < 5; f++) {
        var p = get(TIPS[f]);
        if (!p || p[0] == null) continue;
        var F = base + f;
        var x = p[0], y = p[1];
        if (mirror) x = 1.0 - x;
        if (flip) y = 1.0 - y;

        // 伸展判定: 指先が第2関節より手首から十分遠ければ「伸びている」
        // (閉じた指は演奏不可。距離比較なので mirror/flip の影響を受けない)
        var ext = true;
        if (reqExt) {
            var pip = get(PIPS[f]);
            if (wrist && pip && wrist[0] != null && pip[0] != null) {
                ext = dist2(p, wrist) > dist2(pip, wrist) * extRatio * extRatio;
            }
        }

        outlet(1, [F, x, y]);

        // plotter 指カーソル: 初回は色とサイズを設定、以降は移動時のみ setpoint
        // 閉じた指はカーソルを薄く表示する (状態が変わったときだけ色を送る)
        var cid = "finger" + F;
        if (!cursorInit[F]) {
            cursorInit[F] = true;
            extState[F] = null;   // 下の状態変化判定で必ず色が送られるようにする
        }
        if (ext !== extState[F]) {
            extState[F] = ext;
            var alpha = ext ? 0.9 : 0.15;
            outlet(2, ["pointcolor", cid, CURSOR_RGB[F][0], CURSOR_RGB[F][1], CURSOR_RGB[F][2], alpha]);
            outlet(2, ["pointsize", cid, ext ? 2 : 1.2]);
        }
        // カーソル更新は移動量 + レート制限 (指ごとに 66ms = 約15fps) で間引く。
        // plotter が大きいと 1 回の再描画が重く、頻繁な setpoint がフリーズの原因になるため
        if ((Math.abs(x - lastCX[F]) > CURSOR_MIN_MOVE || Math.abs(y - lastCY[F]) > CURSOR_MIN_MOVE)
            && (now - lastCursorAt[F]) > 66) {
            lastCX[F] = x; lastCY[F] = y;
            lastCursorAt[F] = now;
            outlet(2, ["setpoint", cid, x, y]);
        }

        // タップ判定: 現フレームと前フレームの両方で伸びているときだけ有効
        // (閉→開の瞬間の大きな移動を誤検出しないため)
        if (prevY[F] != null && ext && prevExt[F]) {
            var dy = y - prevY[F];   // 正 = 下向きの動き
            if (dy > thresh && (now - lastFire[F]) > refract) {
                lastFire[F] = now;
                if (dbg) post("hd.fingers: tap 指=" + F + " x=" + x.toFixed(3) + " y=" + y.toFixed(3) + " dy=" + dy.toFixed(3) + "\n");
                // Max のメッセージは深さ優先で同期処理されるため、outlet(0) が返る前に
                // kdtree の結果が inlet 1 → hitResult に届く。指 id はここで確定する
                pendingFinger = F;
                outlet(0, [x, y]);
                pendingFinger = -1;
            }
        }
        prevY[F] = y;
        prevExt[F] = ext;
    }
}

// タップした指の色で、ヒットしたスライス点を plotter 上に塗る
function hitResult(id) {
    var F = pendingFinger;
    if (F < 0) return;
    var prev = lastHit[F];
    if (prev !== null && prev !== id) {
        // 前につかんでいた点を戻す (他の指が現在つかんでいる点は塗ったまま)
        var claimed = false;
        for (var i = 0; i < NFING; i++) if (i !== F && lastHit[i] === prev) claimed = true;
        if (!claimed) {
            outlet(2, ["pointcolor", prev, DEFAULT_RGBA[0], DEFAULT_RGBA[1], DEFAULT_RGBA[2], DEFAULT_RGBA[3]]);
            outlet(2, ["pointsize", prev, 1]);
        }
    }
    lastHit[F] = id;
    outlet(2, ["pointcolor", id, CURSOR_RGB[F][0], CURSOR_RGB[F][1], CURSOR_RGB[F][2], 1]);
    outlet(2, ["pointsize", id, 1.6]);
    if (dbg) post("hd.fingers: hit 指=" + F + " id=" + id + "\n");
}

// ---- パラメータ設定メッセージ ----
function threshold(v)  { thresh = v;  post("hd.fingers: threshold=" + v + "\n"); }
function refractory(v) { refract = v; post("hd.fingers: refractory=" + v + "ms\n"); }
function mirrorx(v)    { mirror = v; }
function flipy(v)      { flip = v; for (var i = 0; i < NFING; i++) prevY[i] = null; }
// 注意: "debug" は js の予約メッセージ(エンジンのメソッド呼び出しトレースが ON になり
// 「0 calling method redraw on MGraphics」がコンソールに洪水する)。taplog に改名した
function taplog(v)     { dbg = v; post("hd.fingers: taplog=" + v + "\n"); }
function requireextended(v) { reqExt = v; post("hd.fingers: requireextended=" + v + "\n"); }
function extratio(v)   { extRatio = v; post("hd.fingers: extratio=" + v + "\n"); }
function reset()       { initState(); }
