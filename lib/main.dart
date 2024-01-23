import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vrit_task_url_shortner/screens/qr_image.dart';
import 'package:vrit_task_url_shortner/core/services.dart';
import 'package:vrit_task_url_shortner/screens/web_view.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? shortenedUrl;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shorten URL'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            TextFormField(
              controller: controller,
              decoration: const InputDecoration(
                  labelText: 'Enter your url here',
                  hintText: 'https://www.example.com',
                  border: UnderlineInputBorder(
                      borderSide: BorderSide(width: 8, color: Colors.black))),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () async {
                shortenedUrl =
                    await Services().shortenUrl(url: controller.text);
                if (shortenedUrl != null) {
                  setState(() {});
                  // ignore: use_build_context_synchronously
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Url Shortened Successfully'),
                          content: SizedBox(
                            height: 100,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () async {
                                        if (await canLaunchUrl(
                                            Uri.parse(shortenedUrl!))) {
                                          await launchUrl(
                                              Uri.parse(shortenedUrl!));
                                        }
                                      },
                                      child: Container(
                                        color: Colors.grey.withOpacity(.2),
                                        child: Text(shortenedUrl!),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(
                                                  text: shortenedUrl!))
                                              .then((_) => ScaffoldMessenger.of(
                                                      context)
                                                  .showSnackBar(const SnackBar(
                                                      content: Text(
                                                          'Urls is copied to the clipboard'))));
                                        },
                                        icon: const Icon(Icons.copy))
                                  ],
                                ),
                                ElevatedButton.icon(
                                    onPressed: () {
                                      controller.clear();
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(Icons.close),
                                    label: const Text('Close'))
                              ],
                            ),
                          ),
                        );
                      });
                }else{
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter valid url")));
                }
              },
              child: const Text('Shorten url'),
            ),
            const SizedBox(height: 50,),
            if (shortenedUrl != null) ...[
              Text("Shortened URL: $shortenedUrl!"),
              const SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => WebViewScreen(
                              shortenedUrl: shortenedUrl!,
                            ))),
                    child: const Text("Open in web view"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => QRImage(
                              qrString: shortenedUrl!,
                            ))),
                    child: const Text("Generate QR code"),
                  ),
                ],
              )
            ],
          ],
        ),
      ),
    );
  }
}
