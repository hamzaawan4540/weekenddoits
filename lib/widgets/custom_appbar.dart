import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoAssetPath;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMyCashTap;
  final VoidCallback? onBizTap;
  final double size;

  const CustomAppBar({
    super.key,
    required this.logoAssetPath,
    this.onMenuTap,
    this.onSearchTap,
    this.onMyCashTap,
    this.onBizTap,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF00A896),
      elevation: 4,
      shadowColor: Colors.black.withOpacity(0.1),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white, size: 28),
        onPressed: onMenuTap ??
            () => ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(content: Text("Menu"))),
      ),
      title: Image.asset(
        logoAssetPath,
        height: size,
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
              color: Colors.white, size: 22),
          onPressed: onSearchTap ??
              () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Search tapped"))),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
