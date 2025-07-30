import 'package:flutter/material.dart';
import 'package:qree/ui/home/model.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart' show launchUrl;

// import '../../model/qritem.dart' show QrType, getName;
import '../../model/qritem.dart';
import '../../shared/constants.dart';
import '../../shared/qrcodeimg.dart' show QrCodeImage;

class HomeView extends StatefulWidget {
  final HomeViewModel model;
  const HomeView({super.key, required this.model});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FocusNode _buttonFocusNode = FocusNode();

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  Widget buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          ListTile(
            title: Text('App version'),
            subtitle: Text(appVersion),
            onTap: () => launchUrl(Uri.parse(sourceRepository)),
          ),
          ListTile(
            title: Text('Source repository'),
            subtitle: Text('github'),
            onTap: () => launchUrl(Uri.parse(sourceRepository)),
          ),
          ListTile(
            title: Text('Developer'),
            subtitle: Text('innomatic'),
            onTap: () => launchUrl(Uri.parse(developerWebsite)),
          ),
        ],
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.model,
      builder: (context, _) {
        return ListView.builder(
          itemCount: widget.model.items.length,
          itemBuilder: (context, index) {
            final item = widget.model.items[index];
            return Card(
              child: ListTile(
                contentPadding: EdgeInsets.only(
                  right: 8,
                  left: 16,
                  top: 4,
                  bottom: 4,
                ),
                leading: item.icon(
                  color: Theme.of(context).colorScheme.tertiary,
                ),
                title: Text(item.title),
                trailing: IconButton(
                  icon: Icon(Icons.settings_rounded),
                  onPressed: () {
                    context.go('/qritem', extra: item);
                  },
                ),
                onTap: () => showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text(
                        item.title,
                        style: TextStyle(color: Colors.black87),
                      ),
                      backgroundColor: Colors.white,
                      contentPadding: EdgeInsets.all(32.0),
                      content: Column(
                        spacing: 8.0,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrCodeImage(data: item.data()),
                          Text(
                            item.label ?? '',
                            style: TextStyle(color: Colors.black87),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(appName)),
      body: buildBody(context),
      drawer: buildDrawer(context),
      floatingActionButton: MenuAnchor(
        // menuChildren: [MenuItemButton(child: Text('test'), onPressed: () {})],
        menuChildren: QrType.values.map((e) {
          return MenuItemButton(
            child: Row(spacing: 8.0, children: [Text(e.name())]),
            onPressed: () {
              final item = QrItem(
                title: 'new item',
                type: e,
                content: QrContent(),
              );
              context.go('/qritem', extra: item);
            },
          );
        }).toList(),
        builder: (context, controller, child) {
          return FloatingActionButton(
            focusNode: _buttonFocusNode,
            onPressed: () {
              controller.isOpen ? controller.close() : controller.open();
            },
            child: Icon(Icons.add),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
