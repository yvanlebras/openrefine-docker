#!/bin/bash
# bash-refine v1.3.4: minimal.sh, Felix Lohmeier, 2020-11-02
# https://gist.github.com/felixlohmeier/d76bd27fbc4b8ab6d683822cdf61f81d
# license: MIT License https://choosealicense.com/licenses/mit/

# =============================== ENVIRONMENT ================================ #

source "${BASH_SOURCE%/*}/bash-refine.sh" || exit 1
cd "${BASH_SOURCE%/*}/" || exit 1
init

# ================================= STARTUP ================================== #

# checkpoint "Startup"; echo
##refine_start; echo

# ================================== IMPORT ================================== #

p="Galaxy file"
projects["Galaxy file"]="/import/input.tabular"

checkpoint "Import"; echo
# project id will be stored in ${projects[tsv file example]}
echo "import file ${projects[$p]} ..."

if curl -fs --write-out "%{redirect_url}\n" \
  --form project-file="@${projects[$p]}" \
  --form project-name="${p}" \
  --form format="text/line-based/*sv" \
  --form options='{
                    "encoding": "UTF-8",
                    "separator": "\t"
                  }' \
  "${endpoint}/command/core/create-project-from-upload$(refine_csrf)" \
  > "${workdir}/${p}.id"
then
  log "imported ${projects[$p]} as ${p}"
else
  error "import of ${projects[$p]} failed!"
fi
refine_store "${p}" "${workdir}/${p}.id" || error "import of ${p} failed!"
echo
#                 <-- insert snippet from templates.sh here -->

# ================================ TRANSFORM ================================= #

# checkpoint "Transform"; echo

#                 <-- insert snippet from templates.sh here -->

# ================================== EXPORT ================================== #

# checkpoint "Export"; echo

#                 <-- insert snippet from templates.sh here -->

# ================================== FINISH ================================== #

checkpoint "Finish"; echo
##refine_stop; echo
checkpoint_stats; echo
#count_output
