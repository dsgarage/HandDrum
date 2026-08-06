{
 "patcher": {
  "fileversion": 1,
  "appversion": {
   "major": 9,
   "minor": 1,
   "revision": 4,
   "architecture": "x64",
   "modernui": 1
  },
  "classnamespace": "box",
  "rect": [
   250.0,
   200.0,
   700.0,
   330.0
  ],
  "boxes": [
   {
    "box": {
     "id": "obj-1",
     "maxclass": "comment",
     "text": "サウンドチェック: ① 下のスピーカーをクリックして ON (青くなる) ② トグルでサイン波 ③ ボタンでドラム再生",
     "patching_rect": [
      30,
      10,
      620,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "comment",
     "text": "テストA: サイン波 440Hz",
     "patching_rect": [
      30,
      45,
      160,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "toggle",
     "patching_rect": [
      30,
      70,
      30,
      30
     ],
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      "int"
     ],
     "parameter_enable": 0
    }
   },
   {
    "box": {
     "id": "obj-4",
     "maxclass": "newobj",
     "text": "cycle~ 440",
     "patching_rect": [
      30,
      110,
      70,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "newobj",
     "text": "*~ 0.1",
     "patching_rect": [
      30,
      145,
      45,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "newobj",
     "text": "*~",
     "patching_rect": [
      90,
      145,
      40,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "signal"
     ]
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "comment",
     "text": "テストB: コーパス先頭2秒 (先に diag-corpus-load で読込)",
     "patching_rect": [
      250,
      45,
      380,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "button",
     "patching_rect": [
      250,
      70,
      30,
      30
     ],
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      "bang"
     ],
     "parameter_enable": 0
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "message",
     "text": "start 0 2000",
     "patching_rect": [
      250,
      110,
      80,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "newobj",
     "text": "play~ sound",
     "patching_rect": [
      250,
      145,
      76,
      22
     ],
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "signal",
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "ezdac~",
     "patching_rect": [
      140,
      220,
      60,
      60
     ],
     "numinlets": 2,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "comment",
     "text": "← ① これをクリックして青くする",
     "patching_rect": [
      210,
      235,
      220,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   }
  ],
  "lines": [
   {
    "patchline": {
     "source": [
      "obj-3",
      0
     ],
     "destination": [
      "obj-4",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-4",
      0
     ],
     "destination": [
      "obj-5",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-5",
      0
     ],
     "destination": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-5",
      0
     ],
     "destination": [
      "obj-11",
      1
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-8",
      0
     ],
     "destination": [
      "obj-9",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-9",
      0
     ],
     "destination": [
      "obj-10",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-10",
      0
     ],
     "destination": [
      "obj-11",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-10",
      0
     ],
     "destination": [
      "obj-11",
      1
     ]
    }
   }
  ],
  "dependency_cache": [],
  "autosave": 0
 }
}