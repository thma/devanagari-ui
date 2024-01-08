# devanagari-ui

A simple web-based app for converting between Devanagari and its transliterations.

## Installation
```bash
git clone https://github.com/thma/devanagari-ui.git

cd devanagari-ui

stack install
```

## Usage

Please note that the application must be run from the root of the project directory in order to find the files in the `static` directory.

If you start the app without any arguments, it will startup on a random free port. But you can also specify a fixed port number as an argument:

```bash
$ devanagari-ui
serving devanagari-ui on http://localhost:52778

$ devanagari-ui 8080
serving devanagari-ui on http://localhost:8080
```

The devanagari-ui will serve a single page web app UI. The page will be available at the specified URL.

The app will also open up a browser window to render the UI.

To use it follow the instructions in the web app. The UI even comes with a short tutorial on the Harvard-Kyoto transliteration scheme.

The web app UI looks like this:

![Alt text](image.png)