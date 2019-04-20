import 'package:flutter/material.dart';
import 'package:nit_andhra/pages/app/app_state.dart';
import 'package:nit_andhra/pages/app/developer/dev_profile.dart';
import 'package:nit_andhra/methods.dart' as methods;
import 'package:nit_andhra/pages/app/developer/developer_class.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DevGridPage extends StatelessWidget {
  final List<Developer> developers;

  const DevGridPage({Key key, this.developers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appState = AppState.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.count(
        crossAxisCount: 2,
        children: _buildDevTiles(context, appState),
      ),
    );
  }

  List<Widget> _buildDevTiles(BuildContext context, AppState appState) {
    List<Widget> devTiles = new List<Widget>.generate(
      developers.length,
      (int i) => Card(
            child: InkWell(
              onTap: () => methods.sendTo(
                    context: context,
                    page: DevProfile(developer: developers[i]),
                    appState: appState,
                  ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Hero(
                      tag: developers[i].facebookLink,
                      child: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(developers[i].imageUrl),
                        radius: 55.0,
                      ),
                    ),
                    Divider(),
                    Text(
                        '${developers[i].firstName} ${developers[i].lastName}'),
                  ],
                ),
              ),
            ),
          ),
    );
    return devTiles;
  }
}
