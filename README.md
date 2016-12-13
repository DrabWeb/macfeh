# macfeh

![Screenshot](https://raw.githubusercontent.com/DrabWeb/macfeh/master/screenshot.png)

Like feh, but on macOS


## Requirements
macOS 10.10+ (tested on 10.12)


## Features
* Borderless rounded viewer
* Toggle viewer background/shadows
* Command line support

## Command line
To use macfeh from the command line, add 

```bash
function macfeh() {
	open -b "drabweb.macfeh" "$@"
}
```

to your shell rc, and use `macfeh [file1] [file2] [file3]...`
