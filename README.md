### Image for building (FSH-based) FHIR Implementation guides with the IG Publisher.

If no commands are given, the image will initialize a new fsh-tank in an empty directory.
See list of scripts in package.json bewlow for a list of available commands.

#### Simple usage
##### Initialize a new fsh tank from an empty directory
```docker run -it -v `pwd`:/builds chorusab/fsh-fhir-build-image:0.9```

##### Run SUSHI on fsh files
```docker run -it -v `pwd`:/builds chorusab/fsh-fhir-build-image:0.9 fsh```

##### Build a IG to `output` folder
```docker run -it -v `pwd`:/builds chorusab/fsh-fhir-build-image:0.9 ig```

#### Volumes and details

The /builds volume is used as base for the fsh-tank.

The image contains a pre-downloaded version of publisher.jar in /fhir/input-cache
If no publisher.jar exists in input-cache the pre-downloaded version is symlinked to the fsh-tank directory.

/root/.fhir is exposed as a volume for caching purposes.

#### Commands
* **serve** Starts an http server on port 8080, should be used with a -p flag to docker run
* **build** Cleans output and cache directories and generates a new IG
* **generate** Cleans output and cache directories and runs SUSHI on fsh files
* **ig** Generates an IG with publisher.jar
* **fsh** Runs SUSHI on fsh files
* **clean** Cleans output and cache directories
* **initialize** (Default if no command is given) Creates a new fsh-tank in an empty directory

All commands but initialize are forwarded to yarn, so see package.json for details on the scripts and to add new commands if needed.

### For more information:
* [FHIR](http://www.hl7.org/fhir/)
* [FSH / FHIR Sorthand specification](http://hl7.org/fhir/uv/shorthand/index.html)
* [FSH School](https://fshschool.org/)
* [IG Publisher](https://confluence.hl7.org/display/FHIR/IG+Publisher+Documentation)

### TODO
* Include plantuml