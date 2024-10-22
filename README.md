# OpenRefine-galaxy-interactivetool
Openrefine Galaxy Interactivetool.


OpenRefine (formerly Google Refine) is a powerful tool for working with messy data: cleaning it;
transforming it from one format into another; and extending it with web services and external data.

Original 2019 work by: Yvan Le Bras https://github.com/yvanlebras
Fork 2024 by: Giuseppe Profiti for BioDec S.r.l. https://github.com/profgiuseppe

Thanks to:

* bash-refine by Felix Lohmeier


# Docker image

## How to build 
  
```{.bash}
docker build . --tag <IMAGE_NAME>
```

## How to execute

```{.bash}
docker network create refine
docker run --rm -d --network refine -p 3333:3333 -v <FULL_PATH_OF_DATA_DIR>:/import <IMAGE_NAME> /openrefine/refine -i 0.0.0.0
```

