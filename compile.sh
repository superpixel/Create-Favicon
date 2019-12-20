#!/bin/sh
BASEDIR=$(dirname "$0")
osacompile -o "$BASEDIR/Create Favicon.app" "$BASEDIR/Create-Favicon.applescript"
echo "Compiled 'Create Favicon.app'"
cp "$BASEDIR/Icon/droplet.icns" "$BASEDIR/Create Favicon.app/Contents/Resources/"
echo "Default icon replaced"