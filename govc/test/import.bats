#!/usr/bin/env bats

load test_helper

@test "import.ova" {
  esx_env

  run govc import.ova $GOVC_IMAGES/${TTYLINUX_NAME}.ova
  assert_success

  run govc vm.destroy ${TTYLINUX_NAME}
  assert_success
}

@test "import.ova with iso" {
  esx_env

  run govc import.ova $GOVC_IMAGES/${TTYLINUX_NAME}-live.ova
  assert_success

  run govc vm.destroy ${TTYLINUX_NAME}-live
  assert_success
}

@test "import.ovf" {
  esx_env

  run govc import.ovf $GOVC_IMAGES/${TTYLINUX_NAME}.ovf
  assert_success

  run govc vm.destroy ${TTYLINUX_NAME}
  assert_success

  # test w/ relative dir
  pushd $BATS_TEST_DIRNAME >/dev/null
  run govc import.ovf ./images/${TTYLINUX_NAME}.ovf
  assert_success
  popd >/dev/null

  run govc vm.destroy ${TTYLINUX_NAME}
  assert_success
}

@test "import.ovf with name in options" {
  esx_env

  name=$(new_id)
  file=$($mktemp --tmpdir govc-test-XXXXX)
  echo "{ \"Name\": \"${name}\"}" > ${file}

  run govc import.ovf -options="${file}" $GOVC_IMAGES/${TTYLINUX_NAME}.ovf
  assert_success

  run govc vm.destroy "${name}"
  assert_success

  rm -f ${file}
}

@test "import.ovf with name as argument" {
  esx_env

  name=$(new_id)

  run govc import.ova -name="${name}" $GOVC_IMAGES/${TTYLINUX_NAME}.ova
  assert_success

  run govc vm.destroy "${name}"
  assert_success
}
