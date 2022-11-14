# See latexmk (1) for details

# tex -> pdf
$pdf_mode=1;

# %O: options
# %S: source file
$pdflatex = 'pdflatex -synctex=1 -interaction=nonstopmode %O %S';
$out_dir = 'build';
@generated_exts = (@generated_exts, 'synctex.gz');

$pdf_previewer = 'mupdf';
# run a command to do the update.
$pdf_update_method = 4;
$pdf_update_command = 'pkill -HUP mupdf';
