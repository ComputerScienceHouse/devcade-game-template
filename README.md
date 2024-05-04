# Devcade-game-template
A template repository for creating games for the Devcade arcade system.

## Whats included

- An initiallized monogame project
- The Devcade library installed
- Resolution setting and basic controls updating
- Build scripts for publishing and packing games

### Getting started
Making a game wth this template is very simple. First, make sure dotnet is installed on your local machine.
Next, create a new repository using this template on GitHub, and clone your new repository.

Once you have a local copy of the repository, open the project in your code editor of choice. 
Make sure to rename all the `.sln` and `.csproj` file from `DevcadeGame` to the name of your game. After that, you are all set.

A script is included to simplify this process. Run `./rename.sh YourGameName` or `./rename.sh CurrentGameName NewGameName` to rename your project.

### Building with build scripts

For Linux / Mac

```sh
. ./publish.bash [Path to banner] [Path to icon]
```

For Windows

```sh
./publish.ps1 [Path to banner] [Path to icon]
```
If arguments are not provided, the script will search for them in the top level of your project directory.

In both cases, the banner and icon must be called 'banner' and 'icon' respectively. The scripts copy these files to your project directory, so running them without args after the first time will always find the banner and icon.

The scripts will create a ZIP file in the project directory with the same name as the containing folder.
