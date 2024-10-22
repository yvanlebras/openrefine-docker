# OpenRefine-galaxy-interactivetool
OpenRefine Galaxy Interactivetool.


OpenRefine (formerly Google Refine) is a powerful tool for working with messy data: cleaning it;
transforming it from one format into another; and extending it with web services and external data.

Original 2019 work by: Yvan Le Bras https://github.com/yvanlebras

Fork 2024 by: Giuseppe Profiti for BioDec S.r.l. https://github.com/profgiuseppe

Thanks to:

* bash-refine by Felix Lohmeier
* the Galaxy community https://galaxyproject.org/

# Content of the repo

```
├── bash-refine
│   ├── bash-refine.sh : helper function to interact with OpenRefine
│   └── myworkflow.sh : script that imports galaxy dataset to OpenRefine 
├── Dockerfile : Docker image building instructions
├── extension : source code for the OpenRefine extension that exports to Galaxy
├── galaxy
│   ├── interactivetool_openrefine.xml : Galaxy tool XML for running the OpenRefine interactive tool
│   └── upload-file.py : helper script that uploads the OpenRefine output to Galaxy
├── LICENSE.txt : code license
└── README.md : this file
```

# How to use

First, build the docker image. The building process will download OpenRefine, compile the extension,
 add it to OpenRefine and copy all the helper scripts.

Modify the interactivetool\_openrefine.xml file so that the **container** line points to the newly built
docker image (in the example it points to *biodec/openrefine-docker*)

Deploy the XML file to Galaxy.

# Docker image

## How to build 
  
```{.bash}
docker build . --tag <IMAGE_NAME>
```

## How to execute

If you want to test the image, you can run:

```{.bash}
docker network create refine
docker run --rm -d --network refine -p 3333:3333 -v <FULL_PATH_OF_DATA_DIR>:/import <IMAGE_NAME> /openrefine/refine -i 0.0.0.0
```

Please be advised that the extension for exporting to Galaxy will not work outside of a Galaxy instance.
