# Flutter Video Trimmer

A Flutter package for trimming videos

## Features

1. Customizable video trimmer.
2. Supports two types of trim viewer, fixed length and scrollable.
3. Video playback control.
4. Retrieving and storing video file.

Also, supports conversion to GIF.

Migrating to v2.0.0: If you were using 1.x.x version of this package, checkout the BREAKING CHANGES by going to the Changelog tab on the pub.dev package page.
Following image shows the structure of the TrimViewer. It consists of the Duration on top (displaying the start, end, and scrubber time), TrimArea consisting of the thumbnails, and TrimEditor which is an overlay that let's you select a portion from the video.

## Usage

Add the dependency video_trimmer to your pubspec.yaml file:

   ```
   dependencies:
  video_trimmer: ^2.0.0
   ```

### Android configuration

No additional configuration is needed for using on Android platform. You are good to go!

### iOS configuratio

1. Add the following keys to your Info.plist file, located in <project root>/ios/Runner/Info.plist:

   ```
   <key>NSCameraUsageDescription</key>
   <string>Used to demonstrate image picker plugin</string>
   <key>NSMicrophoneUsageDescription</key>
   <string>Used to capture audio for image picker plugin</string>
   <key>NSPhotoLibraryUsageDescription</key>
   <string>Used to demonstrate image picker plugin</string>
   ```
   
2. Set the platform version in ios/Podfile to 10.

   ```
    platform :ios, '10'
   ```
   
## Functionalities

### Loading input video file

   ```
   final Trimmer _trimmer = Trimmer();
   await _trimmer.loadVideo(videoFile: file);
   ```

### Saving trimmed video

Returns a string to indicate whether the saving operation was successful.

   ```
   await _trimmer
    .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
    .then((value) {
   setState(() {
    _value = value;
   });
   });
   ```

### Video playback state 

Returns the video playback state. If true then the video is playing, otherwise it is paused.

   ```
   await _trimmer.videoPlaybackControl(
  startValue: _startValue,
  endValue: _endValue,
);
```

### Advanced Command

You can use an advanced FFmpeg command if you require more customization. Just define your FFmpeg command using the ffmpegCommand property and set an output video format using customVideoFormat.

Refer to the Official FFmpeg Documentation for more information.

   ```
   // Example of defining a custom command

// This is already used for creating GIF by
// default, so you do not need to use this.

await _trimmer
    .saveTrimmedVideo(
        startValue: _startValue,
        endValue: _endValue,
        ffmpegCommand:
            '-vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" -loop 0',
        customVideoFormat: '.gif')
    .then((value) {
  setState(() {
    _value = value;
  });
});
```

## Widgets

### Display a video playback area

   ```
   VideoViewer(trimmer: _trimmer)
   ```

### Display the video trimmer area

   ```
   TrimViewer(
  trimmer: _trimmer,
  viewerHeight: 50.0,
  viewerWidth: MediaQuery.of(context).size.width,
  maxVideoLength: const Duration(seconds: 10),
  onChangeStart: (value) => _startValue = value,
  onChangeEnd: (value) => _endValue = value,
  onChangePlaybackState: (value) =>
      setState(() => _isPlaying = value),
)
```

## Example

Before using this example directly in a Flutter app, don't forget to add the video_trimmer & file_picker packages to your pubspec.yaml file.

You can try out this example by replacing the entire content of main.dart file of a newly created Flutter project.

   ```
   import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:video_trimmer/video_trimmer.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Trimmer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Center(
        child: Container(
          child: ElevatedButton(
            child: Text("LOAD VIDEO"),
            onPressed: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles(
                type: FileType.video,
                allowCompression: false,
              );
              if (result != null) {
                File file = File(result.files.single.path!);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) {
                    return TrimmerView(file);
                  }),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

class TrimmerView extends StatefulWidget {
  final File file;

  TrimmerView(this.file);

  @override
  _TrimmerViewState createState() => _TrimmerViewState();
}

class _TrimmerViewState extends State<TrimmerView> {
  final Trimmer _trimmer = Trimmer();

  double _startValue = 0.0;
  double _endValue = 0.0;

  bool _isPlaying = false;
  bool _progressVisibility = false;

  Future<String?> _saveVideo() async {
    setState(() {
      _progressVisibility = true;
    });

    String? _value;

    await _trimmer
        .saveTrimmedVideo(startValue: _startValue, endValue: _endValue)
        .then((value) {
      setState(() {
        _progressVisibility = false;
        _value = value;
      });
    });

    return _value;
  }

  void _loadVideo() {
    _trimmer.loadVideo(videoFile: widget.file);
  }

  @override
  void initState() {
    super.initState();

    _loadVideo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Trimmer"),
      ),
      body: Builder(
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Visibility(
                  visible: _progressVisibility,
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                ),
                ElevatedButton(
                  onPressed: _progressVisibility
                      ? null
                      : () async {
                          _saveVideo().then((outputPath) {
                            print('OUTPUT PATH: $outputPath');
                            final snackBar = SnackBar(
                                content: Text('Video Saved successfully'));
                            ScaffoldMessenger.of(context).showSnackBar(
                              snackBar,
                            );
                          });
                        },
                  child: Text("SAVE"),
                ),
                Expanded(
                  child: VideoViewer(trimmer: _trimmer),
                ),
                Center(
                  child: TrimViewer(
                    trimmer: _trimmer,
                    viewerHeight: 50.0,
                    viewerWidth: MediaQuery.of(context).size.width,
                    maxVideoLength: const Duration(seconds: 10),
                    onChangeStart: (value) => _startValue = value,
                    onChangeEnd: (value) => _endValue = value,
                    onChangePlaybackState: (value) =>
                        setState(() => _isPlaying = value),
                  ),
                ),
                TextButton(
                  child: _isPlaying
                      ? Icon(
                          Icons.pause,
                          size: 80.0,
                          color: Colors.white,
                        )
                      : Icon(
                          Icons.play_arrow,
                          size: 80.0,
                          color: Colors.white,
                        ),
                  onPressed: () async {
                    bool playbackState = await _trimmer.videoPlaybackControl(
                      startValue: _startValue,
                      endValue: _endValue,
                    );
                    setState(() {
                      _isPlaying = playbackState;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```



