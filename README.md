# Moonwarmer Project Format
Here is how a Moonwarmer project folder is structured
```

└── (root of the project folder)
    ├── "_moonwarmer.json" (an important file that helps Moonwarmer recongize a project.)
    └── "chapter(num)" folder (will be loaded when the appropriate DELTARUNE chapter is loaded. chapter0 is the launcher.)
        Note, when Moonwarmer loads the folders below, subfolders will be properly loaded too!
        └── "scripts"/"code"/"objects" folder (where .gml files are held)
        └── "sprites" folder (where sprites .png files are be held)
        └── "shaders" folder (where subfolders exported from ExportShaders.csx are held)
        └── "audio"/"sounds"/"mus" folder (where .wav files are held. .ogg files will not work.)
    └── "_everychapter" folder (will ALWAYS be loaded into the data.win)
        Same structure as a chapter(num) folder.
```

> [!IMPORTANT]
> For non-lts demo mods, chapter0 and _everychapter are the folders that always get loaded.

_moonwarmer.json is a crucial file that stores information about your mod. Read about it below.

# _moonwarmer.json format
*_moonwarmer.json* is a file that is stored in your project folder that makes it a Moonwarmer project. 

Here is how it is structured:

```json
{
    "metadata": 
    {
        "name": "My Visual Mod Name",
        "version": "vVersionNumber",
        "packageID": "hostedurl.modname.authorname"
    },

    "deltaruneVersion": "1.04",
    "supportedPackageTypes": 
    [
        "DELTAMOD",
        "DELTAHUB"
    ],
    "deltaruneVariants":
    [
        "fullgame",
        "demo",
        "demo-lts"
    ]
}
```

Let me break it down for you, user.

## Metadata Section

`metadata` stores all important mod information. It's what makes your mod recognizable.
This section may be familiar to you if you've made a mod in the DELTAMOD/DELTAHUB format.

> [!IMPORTANT]
> If your mod is for the DELTAMOD/DELTAHUB format, please, make the `metadata` values the same as in _deltaModInfo.json

The `name` field is just a visual mod name.

The `version` field is the version of your mod. Increase this everytime you update! It helps other mods recognize your mod better.
*(Note, version format does not have to be the same as in the example. It is simply what I personally use. Just keep it consistent!)*

*`packageID` is a very important field.* It is a *unique* identifier for your mod. It follows this format: `hostedurl.modname.authorname`

Here's how an example would look like: `gamebanana.bettersaves.thej01`
> [!CAUTION]
> *Never, NEVER change this value after release.*

## supportedPackageTypes
**This is an important field!**

The `supportedPackageTypes` field is the supported mod formats this project is packaged with. *Leave this empty if this mod is standalone.*

### Supported Values
- "DELTAMOD"
- "DELTAHUB"

## deltaruneVariants
**This is an important field!**

The `deltaruneVariants` field are the *supported variants of DELTARUNE the project is made for*.

> [!NOTE]
> While it is an *array*, which means it supports several values, *it is recommended for most workflows that this stays at one entry*.

### Supported Values
- "fullgame"
- "demo"
- "demo-lts"

## Other Fields

`deltaruneVersion` is the version of DELTARUNE this mod was made for. 

What should be inputted here is the version displayed on the game's patchnotes.

For example, `1.04`

*Moonwarmer projects can succesfully load into any version of DELTARUNE (as long as it's the same variant). You don't have to update your mod every time the game does to make it work. This is just a helpful value.*

> [!IMPORTANT]
> *Please make this the same as the DELTAMOD/DELTAHUB deltaruneVersion field if you are making this mod for those.*

# Okay, but how do I actually *put* files in my project?
If you've ever used UndertaleModTool's Resource Exporters before, that's essentially how you put all your files in the project. 

`.gml` files are self-explanatory, put the code in the file lol.

`Sprites` should be formatted the same way as the `Export all frames` in UndertaleModTool formats them. (naming scheme, and .png file format.)

`Shaders` should be formatted how ExportShaders.csx formats them (all seperated into their own unique folder)

`Sounds`... are literally just .wav files. It does not get simpler.

For those familiar with Resource Importer scripts in UMT, Moonwarmer uses those under-the-hood (*except for code, code importing is basically fully custom to support merging*), so files are imported the same way.

# Template is helpful, but I feel like I need an example.
[***We have a ton of example projects you can look at and try out here!***](https://github.com/thej01/moonwarmer-example-mods/tree/main/__ExampleMods)

# How do you use the Moonwarmer API?
## [Moonwarmer API Documentation](https://github.com/thej01/moonwarmer-example-mods/wiki)

# I've made my mod! I want to package it with the DELTAMOD format. How do I do that?
### We are working on this :) DELTAMOD 1.2.1 will support Moonwarmer

# I need help!
Either make a github issue (we'll treat it as a help forum)
or join the [***DELTAMODDERS***](https://discord.com/invite/TWkdQQRbPt) server and ping me (thej01) in #modding-help, i will assist you :3

# Credits
- [Mighty Mr. M (Example mods)](https://gamebanana.com/members/4797850)
