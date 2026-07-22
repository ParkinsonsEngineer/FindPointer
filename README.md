# Find Pointer

This application will cause the pointer to change size repeatedly
so that it is easier to locate.

# Install

* Clone this repo.
* Copy the find_pointer.swift file to its final location.

# Setup

* Open the Shortcuts application.
* Click the + icon in the top toolbar to create a new shortcut.
Name it something like "Locate Mouse".
* In the right-hand sidebar search panel,
type "Run Shell Script" and drag it into the main canvas.
* Set the shell field to /bin/bash or /bin/zsh.
* Inside the text block, provide the absolute path to your file:
```shell
/usr/bin/swift /Users/YOUR_USERNAME/path/to/find_pointer.swift
```
* Click the Shortcut Settings / Info panel icon
(the small "i" icon on the right sidebar).
* Click "Add Keyboard Shortcut" and press your preferred key combination
(e.g., Control + Option + Command + M).
