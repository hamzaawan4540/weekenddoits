import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String logoAssetPath;
  final VoidCallback? onMenuTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMyCashTap;
  final VoidCallback? onBizTap;

  const CustomAppBar({
    super.key,
    required this.logoAssetPath,
    this.onMenuTap,
    this.onSearchTap,
    this.onMyCashTap,
    this.onBizTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 91, 148, 234),
      elevation: 1,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: InkWell(
          onTap: onMenuTap ??
              () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Menu tapped"))),
          child: Row(
            children: [
              const Icon(Icons.menu, size: 20, color: Colors.black87),
            ],
          ),
        ),
      ),
      title: Container(
        constraints: const BoxConstraints(maxHeight: 48),
        child: Image.asset(
          logoAssetPath,
          height: 100,
          fit: BoxFit.contain,
        ),
      ),
      actions: [
        IconButton(
          icon: const FaIcon(FontAwesomeIcons.magnifyingGlass,
              color: Colors.black87, size: 18),
          onPressed: onSearchTap ??
              () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text("Search tapped"))),
        ),
        // InkWell(
        //   onTap: onMyCashTap ??
        //       () => ScaffoldMessenger.of(context)
        //           .showSnackBar(const SnackBar(content: Text("myCash tapped"))),
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 8),
        //     child: Row(
        //       children: const [
        //         Text("my",
        //             style: TextStyle(
        //               fontWeight: FontWeight.w700,
        //               fontSize: 14,
        //               fontStyle: FontStyle.italic,
        //               color: Colors.black87,
        //             )),
        //         Text("Cash",
        //             style: TextStyle(
        //               fontWeight: FontWeight.w400,
        //               fontSize: 14,
        //               color: Colors.black87,
        //             )),
        //       ],
        //     ),
        //   ),
        // ),
        // InkWell(
        //   onTap: onBizTap ??
        //       () => ScaffoldMessenger.of(context)
        //           .showSnackBar(const SnackBar(content: Text("Biz tapped"))),
        //   child: Padding(
        //     padding: const EdgeInsets.only(right: 12),
        //     child: Row(
        //       children: const [
        //         FaIcon(
        //           FontAwesomeIcons.briefcase,
        //           size: 16,
        //           color: Colors.deepOrangeAccent,
        //         ),
        //         SizedBox(width: 4),
        //         Text("Biz",
        //             style: TextStyle(
        //                 fontSize: 14,
        //                 fontWeight: FontWeight.w500,
        //                 color: Colors.black87)),
        //       ],
        //     ),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
