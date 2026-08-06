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
   300.0,
   300.0,
   700.0,
   300.0
  ],
  "boxes": [
   {
    "box": {
     "id": "obj-10",
     "maxclass": "comment",
     "text": "サウンドプローブ: 1秒後サイン波 / 4秒後ドラム。注意: ドラムは hand-drum-player を開いて「読込」完了後でないと絶対に鳴らない(buffer sound は同パッチ内にある)",
     "patching_rect": [
      30,
      10,
      640,
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
     "text": "start",
     "patching_rect": [
      30,
      115,
      40,
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
     "id": "obj-5",
     "maxclass": "newobj",
     "text": "cycle~ 440",
     "patching_rect": [
      130,
      115,
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
     "id": "obj-6",
     "maxclass": "newobj",
     "text": "*~ 0.08",
     "patching_rect": [
      130,
      150,
      50,
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
     "maxclass": "newobj",
     "text": "del 4000",
     "patching_rect": [
      230,
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
     "id": "obj-8",
     "maxclass": "message",
     "text": "start 0 2000",
     "patching_rect": [
      230,
      115,
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
     "id": "obj-9",
     "maxclass": "newobj",
     "text": "play~ sound",
     "patching_rect": [
      230,
      150,
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
     "id": "obj-4",
     "maxclass": "newobj",
     "text": "dac~",
     "patching_rect": [
      130,
      200,
      40,
      22
     ],
     "numinlets": 2,
     "numoutlets": 0,
     "outlettype": []
    }
   },
   {
    "box": {
     "id": "obj-11",
     "maxclass": "comment",
     "text": "判定: サイン波×→Max のオーディオ出力/DSP の問題(Options>Audio Status)。サイン波○ドラム×→buffer 空(読込未実行)。コンソールの probe_dsp(1=ON) と probe_buffer_ms(>0=読込済) を確認",
     "patching_rect": [
      30,
      240,
      650,
      34
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-20",
     "maxclass": "newobj",
     "text": "del 2500",
     "patching_rect": [
      420,
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
     "id": "obj-21",
     "maxclass": "newobj",
     "text": "info~ sound",
     "patching_rect": [
      420,
      115,
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
     "id": "obj-22",
     "maxclass": "newobj",
     "text": "print probe_buffer_ms",
     "patching_rect": [
      420,
      150,
      130,
      22
     ],
     "numinlets": 1,
     "numoutlets": 0
    }
   },
   {
    "box": {
     "id": "obj-23",
     "maxclass": "newobj",
     "text": "adstatus switch",
     "patching_rect": [
      560,
      115,
      95,
      22
     ],
     "numinlets": 2,
     "numoutlets": 2,
     "outlettype": [
      "",
      "int"
     ]
    }
   },
   {
    "box": {
     "id": "obj-24",
     "maxclass": "newobj",
     "text": "print probe_dsp",
     "patching_rect": [
      560,
      150,
      95,
      22
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
      "obj-5",
      0
     ],
     "destination": [
      "obj-6",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-6",
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
      "obj-6",
      0
     ],
     "destination": [
      "obj-4",
      1
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
      "obj-4",
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
      "obj-4",
      1
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
      "obj-20",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-20",
      0
     ],
     "destination": [
      "obj-21",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-20",
      0
     ],
     "destination": [
      "obj-23",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-21",
      6
     ],
     "destination": [
      "obj-22",
      0
     ]
    }
   },
   {
    "patchline": {
     "source": [
      "obj-23",
      1
     ],
     "destination": [
      "obj-24",
      0
     ]
    }
   }
  ],
  "dependency_cache": [],
  "autosave": 0
 }
}