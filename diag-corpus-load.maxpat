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
   200.0,
   150.0,
   650.0,
   460.0
  ],
  "boxes": [
   {
    "box": {
     "id": "obj-20",
     "maxclass": "comment",
     "text": "コーパス読込診断: 開くと自動実行。約10秒後に下の数値がバッファ長(ms)になる。0 のままなら読込失敗",
     "patching_rect": [
      30,
      10,
      560,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-1",
     "maxclass": "newobj",
     "text": "loadbang",
     "patching_rect": [
      30,
      45,
      60,
      22
     ],
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-2",
     "maxclass": "newobj",
     "text": "del 1000",
     "patching_rect": [
      30,
      80,
      55,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-3",
     "maxclass": "message",
     "text": "<ここに sampleloop の絶対パスを書いて保存>",
     "patching_rect": [
      30,
      115,
      560,
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
     "id": "obj-4",
     "maxclass": "newobj",
     "text": "fluid.audiofilesin",
     "patching_rect": [
      30,
      150,
      105,
      22
     ],
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-5",
     "maxclass": "newobj",
     "text": "fluid.concataudiofiles @destination sound",
     "patching_rect": [
      30,
      185,
      240,
      22
     ],
     "numinlets": 1,
     "numoutlets": 1,
     "outlettype": [
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-6",
     "maxclass": "newobj",
     "text": "buffer~ sound",
     "patching_rect": [
      300,
      150,
      90,
      22
     ],
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "float",
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-7",
     "maxclass": "newobj",
     "text": "del 9000",
     "patching_rect": [
      30,
      230,
      55,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "bang"
     ]
    }
   },
   {
    "box": {
     "id": "obj-12",
     "maxclass": "button",
     "patching_rect": [
      100,
      230,
      24,
      24
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
     "id": "obj-21",
     "maxclass": "comment",
     "text": "← 再計測",
     "patching_rect": [
      130,
      232,
      80,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-8",
     "maxclass": "newobj",
     "text": "info~ sound",
     "patching_rect": [
      30,
      270,
      76,
      22
     ],
     "numinlets": 1,
     "numoutlets": 10,
     "outlettype": [
      "float",
      "list",
      "float",
      "float",
      "float",
      "float",
      "float",
      "",
      "int",
      ""
     ]
    }
   },
   {
    "box": {
     "id": "obj-9",
     "maxclass": "flonum",
     "patching_rect": [
      30,
      310,
      120,
      22
     ],
     "numinlets": 1,
     "numoutlets": 2,
     "outlettype": [
      "",
      "bang"
     ],
     "parameter_enable": 0
    }
   },
   {
    "box": {
     "id": "obj-22",
     "maxclass": "comment",
     "text": "← バッファ長 (ms)",
     "patching_rect": [
      160,
      312,
      140,
      20
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "newobj",
     "text": "> 0.",
     "patching_rect": [
      30,
      345,
      40,
      22
     ],
     "numinlets": 2,
     "numoutlets": 1,
     "outlettype": [
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-10",
     "maxclass": "toggle",
     "patching_rect": [
      30,
      380,
      24,
      24
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
     "id": "obj-23",
     "maxclass": "comment",
     "text": "← チェックが付けば読込成功",
     "patching_rect": [
      64,
      382,
      200,
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
      "obj-1",
      0
     ],
     "destination": [
      "obj-2",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-1",
      0
     ],
     "destination": [
      "obj-7",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-2",
      0
     ],
     "destination": [
      "obj-3",
      0
     ]
    }
   },
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
      "obj-7",
      0
     ],
     "destination": [
      "obj-8",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-12",
      0
     ],
     "destination": [
      "obj-8",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-8",
      6
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
      "obj-8",
      6
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
      "obj-11",
      0
     ],
     "destination": [
      "obj-10",
      0
     ]
    }
   }
  ],
  "dependency_cache": [],
  "autosave": 0
 }
}