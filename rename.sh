#!/bin/sh

mv DevcadeGame $1
cd $1
mv DevcadeGame.csproj $1.csproj
mv DevcadeGame.sln $1.sln
sed -i "s/DevcadeGame/${1}/g" $1.sln Program.cs app.manifest
sed -i "/namespace/s/DevcadeGame/${1}/g" Game1.cs
