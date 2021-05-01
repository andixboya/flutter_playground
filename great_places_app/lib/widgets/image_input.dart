import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 298) For… accessing directory , which is designed for photo storage!
import 'package:path/path.dart' as path;
// 298) required for writting on the device`s file system and getting the current directory of the device.
// package, used for constructing paths so you can access files!
import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function onSelectImage;
  ImageInput(this.onSelectImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  
  File _storedImage;

  Future<void> _takePicture() async {
    // 298) here the image is taken as future
    // ImagePicker.pickImage old syntax for picker
    final image = ImagePicker();
    final imageFile = await image.getImage(
      // 298) option, which camera the device should use in order to take the picture.
      source: ImageSource.camera,
      maxWidth: 600,
    );
    // 299-300) checkup in case of no pic selection.
    if (imageFile == null) {
      return;
    }

    setState(() {
      // here its just stored in the app`s memory
      // here i think it needeed path, not imageFile directly.
      // imageFile was previously.
      _storedImage = File(imageFile.path);
    });
    // 298) the directory of the app, where it is kept.
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    // 298) base file path name
    final fileName = path.basename(imageFile.path);
    // 298) here the photo is coppied to the directory of the app +'the file`s name'.ß
    // not sure if this was
    final savedImage = await _storedImage.copy('${appDir.path}/$fileName');
    // this is probably for later on?
    // 299-300) oh... this is where you pass the data to the above... widget... damn.
    widget.onSelectImage(savedImage);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: FlatButton.icon(
            icon: Icon(Icons.camera),
            label: Text('Take Picture'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _takePicture,
          ),
        ),
      ],
    );
  }
}
