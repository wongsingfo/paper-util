from cycler import cycler
from matplotlib import patches, ticker
import argparse
import json
import matplotlib.colors as mcolors
import matplotlib.pyplot as plt
import sys
import numpy as np
import os
import pandas as pd
import pyoverleaf

## Global configuration

# constrained_layout automatically adjusts subplots and decorations like legends and colorbars
# so that they fit in the figure window while still preserving, as best they can, the logical
# layout requested by the user. constrained_layout is similar to tight_layout, but uses a constraint
# solver to determine the size of axes that allows them to fit.

linestyle_str = [
    ("solid", "solid"),  # Same as (0, ()) or '-'
    ("dotted", "dotted"),  # Same as (0, (1, 1)) or ':'
    ("dashed", "dashed"),  # Same as '--'
    ("dashdot", "dashdot"),
]  # Same as '-.'

linestyle_tuple = [
    ("loosely dotted", (0, (1, 10))),
    ("dotted", (0, (1, 1))),
    ("densely dotted", (0, (1, 1))),
    ("long dash with offset", (5, (10, 3))),
    ("loosely dashed", (0, (5, 10))),
    ("dashed", (0, (5, 5))),
    ("densely dashed", (0, (5, 1))),
    ("loosely dashdotted", (0, (3, 10, 1, 10))),
    ("dashdotted", (0, (3, 5, 1, 5))),
    ("densely dashdotted", (0, (3, 1, 1, 1))),
    ("dashdotdotted", (0, (3, 5, 1, 5, 1, 5))),
    ("loosely dashdotdotted", (0, (3, 10, 1, 10, 1, 10))),
    ("densely dashdotdotted", (0, (3, 1, 1, 1, 1, 1))),
]

# ['#3853a4', '#146533', '#ed1f24', '#708191', '#faa51a', '#b9519f']
# palette = ['#EE6677', '#4477AA', '#8ECFC9', '#FFBE7A', '#BEB8DC', '#E7DAD2']  # Genshin by Yuhan
palette = ["#F27970", "#BB9727", "#54B345", "#32B897", "#05B9E2", "#8983BF"]
patterns = [
    "",
    "/",
    "\\",
    "x",
    ".",
    "o",
]  #  "|" , "-" , "+" , "x", "o", "O", ".", "*" ]
linestyles = ["-", "--", ":", "-.", (0, (3, 1, 1, 1, 1, 1)), (5, (10, 3))]
markers = ["v", "*", ".", "s", "1", "x"]

plt.rcParams["figure.constrained_layout.use"] = True

plt.rcParams["figure.figsize"] = [4.0, 3.0]
plt.rcParams["figure.dpi"] = 80
plt.rcParams["savefig.dpi"] = 300
plt.rcParams["savefig.bbox"] = "tight"

plt.rcParams["font.size"] = 18
plt.rcParams["font.family"] = "Arial"
plt.rcParams["legend.fontsize"] = "medium"
plt.rcParams["legend.facecolor"] = "white"
plt.rcParams["legend.edgecolor"] = "white"
plt.rcParams["legend.framealpha"] = 0.9
plt.rcParams["figure.titlesize"] = "medium"
plt.rcParams["grid.linestyle"] = "--"
plt.rcParams["xtick.direction"] = "in"
plt.rcParams["ytick.direction"] = "in"
plt.rcParams["axes.prop_cycle"] = cycler(color=palette) + cycler(linestyle=linestyles)


transparency = 0.5


def get_transparent_color(color):
    c = mcolors.hex2color(color)
    c = tuple(
        map(lambda x: x * transparency + (1.0 - transparency), mcolors.hex2color(c))
    )
    hex_color = "#{:02X}{:02X}{:02X}".format(
        int(c[0] * 255), int(c[1] * 255), int(c[2] * 255)
    )
    return hex_color


# `colors` for border lines and `colors_fill` for filled areas
colors = plt.rcParams["axes.prop_cycle"].by_key()["color"]
colors_fill = list(map(get_transparent_color, colors))


def generate_test_fig(args):
    x = np.arange(0, 4, 0.05)

    fig, ax = plt.subplots()
    fig.set_size_inches((4, 3))

    ax.plot(x, np.sin(x * np.pi), label="sin")
    ax.plot(x, np.sin((x + 0.2) * np.pi), label="sin")
    ax.plot(x, np.sin((x + 0.4) * np.pi), label="sin")
    ax.plot(x, np.sin((x + 0.6) * np.pi), label="sin")
    ax.plot(x, np.sin((x + 0.8) * np.pi), label="sin")
    ax.plot(x, np.sin((x + 1.0) * np.pi), label="sin")

    ax.set_xlabel("$x$")
    ax.set_ylabel(r"$y = sin(x + \phi)$")
    ax.set_title("Sine wave")

    ax.grid(True)

    ax.legend(
        loc="upper center",
        frameon=False,
        bbox_to_anchor=(-0.1, 1.5, 1.2, 0.15),
        ncol=3,
        borderaxespad=0,
        handlelength=1.5,
        mode="expand",
        handletextpad=0.5,
        columnspacing=1,
        labelspacing=0.3,
    )

    savefig(args, "figure-chengke/test.pdf")


def savefig(args, filename):
    plt.savefig(filename)
    upload(args, filename)


def upload(args, filename):
    if not args.upload:
        # print("If you want to upload, please set --upload")
        return

    with open(filename, "rb") as fin:
        file_bytes = fin.read()

    outfile = os.path.basename(filename)
    print("Uploading", outfile, end=" ...")
    sys.stdout.flush()
    args.overleaf_api.project_upload_file(
        args.overleaf_project_id, args.overleaf_folder_id, outfile, file_bytes
    )
    print(" Done")


