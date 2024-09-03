import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Page',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  WebSocketChannel channel = IOWebSocketChannel.connect(Uri.parse("ws://echo.websocket.org"));
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              TextFormField(
                controller: textEditingController,
                decoration: const InputDecoration(
                  hintText: "Message",
                  focusedBorder: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder()
                )
              ),

              const SizedBox(height: 10),

              StreamBuilder(
                  stream: channel.stream,
                  builder: (context,snapshot)=>
                      Text(
                        "${snapshot.hasData ? snapshot.data : "No Data"}"
                      )
              )

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          channel.sink.add(textEditingController.text);
        },
        tooltip: "Send",
        child: const Icon(Icons.send),
      ), 
    );
  }
}


