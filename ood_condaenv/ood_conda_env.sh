#!/bin/bash

ONDEMAND_WORKDIR="$HOME/ondemand"

CONDA_ENV_LIST="$ONDEMAND_WORKDIR/conda-env-list.txt"
CONDA_JUPYTER_ENV_LIST="$ONDEMAND_WORKDIR/conda-jupyter-env-list.txt"
CONDA_R_ENV_LIST="$ONDEMAND_WORKDIR/conda-r-env-list.txt"
CONDA_TB_ENV_LIST="$ONDEMAND_WORKDIR/conda-tb-env-list.txt"

[ ! -d $ONDEMAND_WORKDIR ] &&  mkdir $ONDEMAND_WORKDIR

# module is not available when PUN is started by the apache server. So we have to define it by ourselves
[ ! "$(declare -fF module)" ] && source /etc/profile.d/00-modulepath.sh && source /etc/profile.d/modules.sh && source /etc/profile.d/z01_StdEnv.sh

source ~/.bashrc
module --force purge 
module load StdEnv
module load miniconda 

rm -rf ${CONDA_ENV_LIST}
#echo "Listing all conda environments ..."
conda-env list|grep -v -e '#' -e '^base ' -e 'ycrc_default' -e 'ycrc_tensorboard' |cut -d' ' -f1  > ${CONDA_ENV_LIST}
sed -i '/^$/d' ${CONDA_ENV_LIST} # remove white lines

rm -rf ${CONDA_JUPYTER_ENV_LIST}
rm -rf ${CONDA_R_ENV_LIST}
rm -rf ${CONDA_TB_ENV_LIST}

touch ${CONDA_JUPYTER_ENV_LIST}
touch ${CONDA_R_ENV_LIST}
touch ${CONDA_TB_ENV_LIST}

_conda_envs=$(cat ${CONDA_ENV_LIST})
for _conda_env in ${_conda_envs}; do
    conda activate ${_conda_env}
 
    has_jupyter='false'
    has_jupyterlab='false'
    which jupyter &> /dev/null && has_jupyter='true'
    which jupyter-lab &> /dev/null && has_jupyterlab='true'
    if [ $has_jupyterlab == 'true' ]; then
        echo "${_conda_env}:true" >> ${CONDA_JUPYTER_ENV_LIST}
    elif [ $has_jupyter  == 'true' ]; then
        echo "${_conda_env}:false" >> ${CONDA_JUPYTER_ENV_LIST}
    fi
    which R >& /dev/null && echo ${_conda_env} >> ${CONDA_R_ENV_LIST}
    which tensorboard >& /dev/null && echo ${_conda_env} >> ${CONDA_TB_ENV_LIST}
    conda deactivate
done

exit 0


