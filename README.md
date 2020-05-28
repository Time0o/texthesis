# pdflatex Thesis and Presentation Makefile Template

## Usage

Clone texthesis to a local directory, then run `make init` and `make`, i.e.:

```
> git clone https://github.com/Time0o/texthesis
> cd texthesis
> make init
> make
> cd ..
```

The directory into which you cloned texthesis should then look like this:

```
├── bib
│   └── bibliography.bib
├── tex
│   └── report.tex
└── texmake
    ├── out
    │   └── ...
    ├── pdf
    │   └── report.pdf
    └── ...
```

Modify `tex/report.tex` and `bib/bibliography.bib` to create your thesis  and
run `make` from the `texthesis` directory once more to update `report.pdf`.
Alternatively, `make report_noref` will update `report.pdf` without updating
references and citations (which is useful for fast prototyping).
