from cycler import cycler
from matplotlib import patches, ticker
import argparse
import json
import matplotlib.colors as mcolors
import matplotlib.font_manager as font_manager
import matplotlib.pyplot as plt
import numpy as np
import os
import pandas as pd
import pyoverleaf
import re
import sys


## Presets

linestyle_str = [
    ("solid", "solid"),  # Same as (0, ()) or '-'
    ("dotted", "dotted"),  # Same as (0, (1, 1)) or ':'
    ("dashed", "dashed"),  # Same as '--'
    ("dashdot", "dashdot"),  # Same as '-.'
]

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


# Take a color in hexadecimal format and return a new color with a certain
# level of transparency applied to it.
def get_transparent_color(color, transparency=0.5):
    c = mcolors.hex2color(color)
    c = [*map(lambda x: x * transparency + (1.0 - transparency), mcolors.hex2color(c))]
    hex_color = "#{:02X}{:02X}{:02X}".format(
        int(c[0] * 255), int(c[1] * 255), int(c[2] * 255)
    )
    return hex_color


palette = ['#EE6677', '#4477AA', '#8ECFC9', '#FFBE7A', '#BEB8DC', '#E7DAD2'] # Genshin by Yuhan
palette = ["#F27970", "#BB9727", "#54B345", "#32B897", "#05B9E2", "#8983BF"] # Rainblow
palette = ["#3853a4", "#146533", "#ed1f24", "#708191", "#faa51a", "#b9519f"] # Contrast

patterns = [ "|" , "-" , "+" , "x", "o", "O", ".", "*" ]
patterns = ["", "/", "\\", "x", ".", "o"]
patterns = ["", "/", "\\", ".", "o", "//", "\\\\", "|", "-", "+", "x", "*"]

linestyles = ["-", "--", ":", "-.", (0, (3, 1, 1, 1, 1, 1)), (5, (10, 3))]

# See: https://matplotlib.org/stable/gallery/lines_bars_and_markers/marker_reference.html
markers = ["v", "*", ".", "s", "1", "x"]

# `colors` for border lines and `colors_fill` for filled areas
colors = plt.rcParams["axes.prop_cycle"].by_key()["color"]
colors_fill = list(map(get_transparent_color, colors))


## Global configuration

# WARNING: sometimes the axes are not aligned when generating PDF.
# plt.rcParams["figure.constrained_layout.use"] = True
# plt.rcParams["savefig.bbox"] = "tight"

# This is to make the font type of the PDF and PS files to be Type 42,
# which is required by most of the conference papers.
plt.rcParams['pdf.fonttype'] = 42
plt.rcParams['ps.fonttype'] = 42

# Use `plt.subplots_adjust(left=0.5)` to adjust.
plt.rcParams["figure.subplot.left"] = 0.2
plt.rcParams["figure.subplot.right"] = 0.9
plt.rcParams["figure.subplot.bottom"] = 0.11
plt.rcParams["figure.subplot.top"] = 0.88
plt.rcParams["figure.subplot.wspace"] = 0.2
plt.rcParams["figure.subplot.hspace"] = 0.2

plt.rcParams["figure.figsize"] = [4.0, 3.0]
plt.rcParams["figure.dpi"] = 80
plt.rcParams["savefig.dpi"] = 300
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

## Helper Functions


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


def plot_test_figure(args):
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

    # https://matplotlib.org/stable/api/_as_gen/matplotlib.axes.Axes.legend.html
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

    savefig(args, args.output)


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--input", type=str, help="Input file path")
    parser.add_argument("--output", type=str, default="test.pdf")
    parser.add_argument("--upload", help="Upload to Overleaf", action="store_true")
    parser.add_argument("--plot", type=str, default="test_figure")

    args = parser.parse_args()

    function_name = f"plot_{args.plot}"
    function = globals()[function_name]
    function(args)
