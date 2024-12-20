# Set variables
$DeviceSize = "1440x3120"
$ON_DEVICE_OUTPUT_FILE = "/sdcard/test_video.mp4"
$OUTPUT_VIDEO = "./test/videos/test_video"
$DRIVER_PATH = "./test/integration_test/driver.dart"
$TEST_PATH = "./test/integration_test/integration_test.dart"
$DeviceId = "emulator-5554"

# Record the screen on the device
Start-Process -NoNewWindow -FilePath adb -ArgumentList "shell screenrecord --size $DeviceSize $ON_DEVICE_OUTPUT_FILE" -PassThru

# Run the Flutter drive test
flutter drive --device-id=$DeviceId --driver=$DRIVER_PATH --target=$TEST_PATH

# Pull the video file from the device
adb pull $ON_DEVICE_OUTPUT_FILE $OUTPUT_VIDEO