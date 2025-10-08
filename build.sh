#!/bin/sh

shopt -s nullglob

# gcc_root=/depot/opensource/gcc/v10.3.0
gcc_root=/usr
sandbox=$(realpath $(dirname -- ${0}))
echo $sandbox

comp_list=ALL
build_type=release
build_root=build/${build_type}.mk
install_root=build/${build_type}

if [[ -n $1 ]]; then
  comp_list=$1
fi


find ${sandbox} -type d -name "export" | while IFS= read -r dir; do
  repo_name=${dir#${sandbox}/}
  repo_name=${repo_name%%/*}
  export_name=$(basename -- $(dirname -- ${dir}))

  export_include=${install_root}/${repo_name}/include/${export_name}
  export_src=${install_root}/${repo_name}/src/${export_name}

  for headers in ${dir}/*.h* ; do
    mkdir -p ${export_include}
    cp ${headers} ${export_include}/
    echo "${headers} -> ${export_include}"
  done

  for sources in ${dir}/*.c* ; do
    mkdir -p ${export_src}
    cp ${sources} ${export_src}/
    echo "${sources} -> ${export_src}"
  done
done

cmake -B ${build_root} \
  -DCOMP_LIST="${comp_list}" \
  -DCMAKE_BUILD_TYPE=${build_type^} \
  -DCMAKE_INSTALL_PREFIX=${sandbox}/${install_root} \
  -DCMAKE_C_COMPILER=${gcc_root}/bin/gcc \
  -DCMAKE_CXX_COMPILER=${gcc_root}/bin/g++ \
  -DCMAKE_MODULE_PATH=${sandbox}/cmake \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
  -DUV_REF_BUILD=${sandbox}/${install_root} # For test-only

cmake --build ${build_root}
cmake --install ${build_root}
