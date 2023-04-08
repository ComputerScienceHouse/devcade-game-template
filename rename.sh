#!/bin/sh

if [ $# -eq 2 ]
then
    mv $1 $2
    cd $2
    mv $1.csproj $2.csproj
    mv $1.sln $2.sln
    sed -i "s/${1}/${2}/g" $2.sln Program.cs app.manifest
    sed -i "/namespace/s/${1}/${2}/g" Game1.cs
else
    mv DevcadeGame $1
    cd $1
    mv DevcadeGame.csproj $1.csproj
    mv DevcadeGame.sln $1.sln
    sed -i "s/DevcadeGame/${1}/g" $1.sln Program.cs app.manifest
    sed -i "/namespace/s/DevcadeGame/${1}/g" Game1.cs
fi

