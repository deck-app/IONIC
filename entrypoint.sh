#!/bin/bash
npm i -g @ionic/cli
ionic start ionic-cd sidemenu --type=react
# ionic start . tabs --type=angular --capacitor
cd ionic-cd
ionic serve
exec "$@"