// hd.samplepath.js — sampleloop パスの生成 (チェックはパッチ側の [folder] が担当)
//
// 役割:
//   1. 起動時 (loadbang) にパッチのフルパス (this.patcher.filepath) から
//      <パッチのある場所>/sampleloop を POSIX 形式で生成してテキスト欄に表示
//   2. [読込] 実行時 (inlet 0 にパスのシンボルが届く) に POSIX 形式へ正規化して通過させる
//
// 出力: outlet 0 — 読込要求パス (→ パッチ側の検証チェーン [folder] → gate → fluid.audiofilesin)
//       outlet 1 — 表示用パス (→ prepend set → textedit)。起動時にも検証チェーンへ送られる
//       outlet 2 — "set <エラー文字列>" (パス取得不可時のみ)
//       outlet 3 — コーパス保存/読込用パス "save|load <sound.wav> <slicepoints.wav> <kdtree.json> <normalized.json>"
//                  (メッセージ "corpuspaths save" / "corpuspaths load" への応答。→ route save load)

inlets = 1;
outlets = 4;

function loadbang() { defaults(); }
function bang()     { defaults(); }

function defaults() {
    var p = defaultPath();
    if (p === null) {
        outlet(2, ["set", "パス取得不可(パッチ未保存)"]);
        return;
    }
    post("hd.samplepath: " + p + "\n");
    outlet(1, p);
}

// [読込] からのパスを正規化して検証チェーンへ
// textedit は内容を "text <本文>" というセレクタ付きで送ってくるため、先頭の text を除去する。
// さらに前後の空白・改行・引用符を除去してから POSIX 形式に変換する
function anything() {
    if (inlet !== 0) return;
    var parts = arrayfromargs(arguments);
    var raw;
    if (messagename === "text") {
        raw = parts.join(" ");                       // textedit 形式: "text <パス>"
    } else {
        raw = String(messagename);                   // 素のシンボルで届いた場合
        if (parts.length > 0) raw += " " + parts.join(" ");   // スペース入りパスの復元
    }
    var cleaned = raw.replace(/^[\s"']+|[\s"']+$/g, "");
    if (cleaned === "") return;
    var out = toPosix(cleaned);
    post("hd.samplepath: 読込要求 " + out + "\n");
    outlet(0, out);
}

function defaultPath() {
    var dir = patchDir();
    return (dir === null) ? null : dir + "sampleloop";
}

// コーパス4ファイルの絶対パスを op ("save"/"load") 付きで outlet 3 へ送る
// 保存先はパッチ同階層の corpus.* (サブフォルダは Max からは mkdir できないため使わない)
function corpuspaths(op) {
    var dir = patchDir();
    if (dir === null) {
        outlet(2, ["set", "パス取得不可(パッチ未保存)"]);
        return;
    }
    if (op !== "save" && op !== "load") return;
    if (op === "load" && !corpusExists(dir)) {
        outlet(2, ["set", "コーパス未保存 — 先に[コーパス保存]"]);
        post("hd.samplepath: corpus load 中止(corpus.* が見つかりません)\n");
        return;
    }
    outlet(3, [op,
        dir + "corpus.sound.wav",
        dir + "corpus.slicepoints.wav",
        dir + "corpus.kdtree.json",
        dir + "corpus.normalized.json"]);
    post("hd.samplepath: corpus " + op + " → " + dir + "corpus.*\n");
}

// コーパス4ファイルが全て存在するか (File はファイルの存在確認には信頼できる。Folder は不可)
function corpusExists(dir) {
    var names = ["corpus.sound.wav", "corpus.slicepoints.wav", "corpus.kdtree.json", "corpus.normalized.json"];
    for (var i = 0; i < names.length; i++) {
        var f = new File(dir + names[i]);
        var ok = f.isopen;
        f.close();
        if (!ok) return false;
    }
    return true;
}

function patchDir() {
    var fp = this.patcher.filepath;
    if (!fp || fp === "") return null;
    fp = toPosix(fp);
    var cut = fp.lastIndexOf("/");
    if (cut < 0) return null;
    return fp.substring(0, cut + 1);
}

// Max 内部形式 "Macintosh HD:/Users/..." を POSIX "/Users/..." に変換する
function toPosix(p) {
    var m = String(p).match(/^([^:]+):(\/.*)$/);
    if (!m) return p;   // すでに POSIX 形式
    var vol = m[1], rest = m[2];
    // 起動ボリュームの標準ディレクトリならボリューム名を外すだけでよい
    if (/^\/(Users|Applications|Library|System|private|opt|Volumes)\//.test(rest)) return rest;
    // 外付けボリュームは /Volumes/<ボリューム名>/... に読み替える
    return "/Volumes/" + vol + rest;
}
