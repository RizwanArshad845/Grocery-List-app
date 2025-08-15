// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:grocery_list_app/UI/purchased_history_ui.dart';
// import '../Providers/state_notfier_provider.dart';
// import '../classes/grocery_details_class.dart';
//
// class GroceryScreen extends ConsumerStatefulWidget {
//   @override
//   ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
// }
//
// class _GroceryScreenState extends ConsumerState<GroceryScreen>
//     with TickerProviderStateMixin {
//   final TextEditingController _controller = TextEditingController();
//   late AnimationController _fabAnimationController;
//   late AnimationController _headerAnimationController;
//   late Animation<double> _fabScaleAnimation;
//   late Animation<Offset> _headerSlideAnimation;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Initialize animation controllers
//     _fabAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//
//     _headerAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//
//     // Initialize animations
//     _fabScaleAnimation = Tween<double>(
//       begin: 0.0,
//       end: 1.0,
//     ).animate(CurvedAnimation(
//       parent: _fabAnimationController,
//       curve: Curves.elasticOut,
//     ));
//
//     _headerSlideAnimation = Tween<Offset>(
//       begin: const Offset(0, -1),
//       end: Offset.zero,
//     ).animate(CurvedAnimation(
//       parent: _headerAnimationController,
//       curve: Curves.bounceOut,
//     ));
//
//     // Start animations
//     _headerAnimationController.forward();
//     _fabAnimationController.forward();
//   }
//
//   @override
//   void dispose() {
//     _fabAnimationController.dispose();
//     _headerAnimationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final groceryAsyncValue = ref.watch(groceryListProvider);
//     final filter = ref.watch(filterProvider);
//
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       appBar: AppBar(
//         elevation: 0,
//         title: SlideTransition(
//           position: _headerSlideAnimation,
//           child: Text(
//             'Grocery List',
//             style: GoogleFonts.poppins(
//               fontWeight: FontWeight.bold,
//               fontSize: 24,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.transparent,
//         foregroundColor: Colors.white,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [
//                 Colors.lightGreen.shade600,
//                 Colors.lightGreen.shade800,
//               ],
//             ),
//           ),
//         ),
//         actions: [
//           _buildAnimatedIconButton(
//             icon: filter == FilterType.purchased
//                 ? Icons.check_box_rounded
//                 : Icons.check_box_outline_blank_rounded,
//             tooltip: filter == FilterType.purchased
//                 ? 'Show Unpurchased'
//                 : 'Show Purchased',
//             onPressed: () {
//               ref.read(filterProvider.notifier).state =
//               filter == FilterType.purchased
//                   ? FilterType.unpurchased
//                   : FilterType.purchased;
//             },
//           ),
//           _buildAnimatedIconButton(
//             icon: Icons.history_rounded,
//             tooltip: "Purchase History",
//             onPressed: () {
//               Navigator.push(
//                 context,
//                 PageRouteBuilder(
//                   pageBuilder: (context, animation, secondaryAnimation) =>
//                       PurchasedHistoryScreen(),
//                   transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                     return SlideTransition(
//                       position: animation.drive(
//                         Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
//                             .chain(CurveTween(curve: Curves.easeInOut)),
//                       ),
//                       child: child,
//                     );
//                   },
//                 ),
//               );
//             },
//           ),
//         ],
//       ),
//       body: groceryAsyncValue.when(
//         data: (fullList) {
//           final filteredItems = ref.watch(filteredGroceryListProvider(fullList));
//
//           return Column(
//             children: [
//               // Animated Header Cards
//               SlideTransition(
//                 position: _headerSlideAnimation,
//                 child: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         Colors.lightGreen.shade800,
//                         Colors.transparent,
//                       ],
//                       stops: const [0.0, 1.0],
//                     ),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
//                     child: Row(
//                       children: [
//                         _buildAnimatedInfoCard(
//                           "Pending",
//                           fullList.where((item) => !item.purchased).length,
//                           Colors.orange.shade50,
//                           Colors.orange.shade700,
//                           Icons.shopping_cart_rounded,
//                           0,
//                         ),
//                         const SizedBox(width: 12),
//                         _buildAnimatedInfoCard(
//                           "Completed",
//                           fullList.where((item) => item.purchased).length,
//                           Colors.green.shade50,
//                           Colors.green.shade700,
//                           Icons.check_circle_rounded,
//                           1,
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               // List with Enhanced Animations
//               Expanded(
//                 child: filteredItems.isEmpty
//                     ? Center(
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       TweenAnimationBuilder<double>(
//                         tween: Tween(begin: 0.0, end: 1.0),
//                         duration: const Duration(milliseconds: 1000),
//                         builder: (context, value, child) {
//                           return Transform.scale(
//                             scale: value,
//                             child: Opacity(
//                               opacity: value,
//                               child: Icon(
//                                 Icons.shopping_basket_outlined,
//                                 size: 80,
//                                 color: Colors.grey[400],
//                               ),
//                             ),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         "No items yet",
//                         style: GoogleFonts.poppins(
//                           fontSize: 18,
//                           color: Colors.grey[600],
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                       const SizedBox(height: 8),
//                       Text(
//                         "Add your first grocery item below",
//                         style: GoogleFonts.poppins(
//                           fontSize: 14,
//                           color: Colors.grey[500],
//                         ),
//                       ),
//                     ],
//                   ),
//                 )
//                     : AnimationLimiter(
//                   child: ListView.builder(
//                     physics: const BouncingScrollPhysics(),
//                     itemCount: filteredItems.length,
//                     itemBuilder: (context, index) {
//                       final item = filteredItems[index];
//                       return AnimationConfiguration.staggeredList(
//                         position: index,
//                         duration: const Duration(milliseconds: 400),
//                         child: SlideAnimation(
//                           verticalOffset: 50,
//                           child: FadeInAnimation(
//                             child: _buildEnhancedListItem(item, index),
//                           ),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//
//               // Enhanced Add Item Field
//               ScaleTransition(
//                 scale: _fabScaleAnimation,
//                 child: _buildEnhancedAddItemField(),
//               ),
//             ],
//           );
//         },
//         loading: () => Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               TweenAnimationBuilder<double>(
//                 tween: Tween(begin: 0.0, end: 1.0),
//                 duration: const Duration(seconds: 1),
//                 builder: (context, value, child) {
//                   return Transform.rotate(
//                     angle: value * 2 * 3.14159,
//                     child: CircularProgressIndicator(
//                       valueColor: AlwaysStoppedAnimation(Colors.lightGreen.shade700),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 16),
//               Text(
//                 "Loading your groceries...",
//                 style: GoogleFonts.poppins(color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//         error: (err, _) => Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
//               const SizedBox(height: 16),
//               Text(
//                 'Oops! Something went wrong',
//                 style: GoogleFonts.poppins(
//                   fontSize: 18,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//               Text(
//                 'Error: $err',
//                 style: GoogleFonts.poppins(color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildAnimatedIconButton({
//     required IconData icon,
//     required String tooltip,
//     required VoidCallback onPressed,
//   }) {
//     return TweenAnimationBuilder<double>(
//       tween: Tween(begin: 0.8, end: 1.0),
//       duration: const Duration(milliseconds: 300),
//       builder: (context, scale, child) {
//         return Transform.scale(
//           scale: scale,
//           child: IconButton(
//             icon: Icon(icon),
//             tooltip: tooltip,
//             onPressed: () {
//               // Add a small bounce animation
//               setState(() {});
//               onPressed();
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   Widget _buildAnimatedInfoCard(
//       String title,
//       int count,
//       Color bgColor,
//       Color textColor,
//       IconData icon,
//       int index,
//       ) {
//     return Expanded(
//       child: TweenAnimationBuilder<double>(
//         tween: Tween(begin: 0.0, end: 1.0),
//         duration: Duration(milliseconds: 600 + (index * 200)),
//         curve: Curves.elasticOut,
//         builder: (context, value, child) {
//           return Transform.scale(
//             scale: value,
//             child: Card(
//               elevation: 8,
//               color: bgColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Container(
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: textColor.withOpacity(0.2),
//                       blurRadius: 8,
//                       offset: const Offset(0, 4),
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(icon, color: textColor, size: 24),
//                           const SizedBox(width: 8),
//                           Text(
//                             title,
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 16,
//                               color: textColor,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 8),
//                       TweenAnimationBuilder<int>(
//                         tween: IntTween(begin: 0, end: count),
//                         duration: const Duration(milliseconds: 1000),
//                         builder: (context, value, child) {
//                           return Text(
//                             '$value',
//                             style: GoogleFonts.poppins(
//                               fontWeight: FontWeight.bold,
//                               fontSize: 28,
//                               color: textColor,
//                             ),
//                           );
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
//
//   Widget _buildEnhancedListItem(GroceryItem item, int index) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//       child: Material(
//         elevation: item.purchased ? 2 : 4,
//         borderRadius: BorderRadius.circular(16),
//         color: item.purchased ? Colors.grey[100] : Colors.white,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: () => togglePurchased(item.id, !item.purchased),
//           child: Container(
//             padding: const EdgeInsets.all(16),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(16),
//               border: Border.all(
//                 color: item.purchased
//                     ? Colors.green.withOpacity(0.3)
//                     : Colors.transparent,
//                 width: 2,
//               ),
//             ),
//             child: Row(
//               children: [
//                 // Animated Checkbox
//                 GestureDetector(
//                   onTap: () => togglePurchased(item.id, !item.purchased),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     width: 24,
//                     height: 24,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: item.purchased
//                           ? Colors.green.shade600
//                           : Colors.transparent,
//                       border: Border.all(
//                         color: item.purchased
//                             ? Colors.green.shade600
//                             : Colors.grey.shade400,
//                         width: 2,
//                       ),
//                     ),
//                     child: item.purchased
//                         ? const Icon(
//                       Icons.check,
//                       size: 16,
//                       color: Colors.white,
//                     )
//                         : null,
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//
//                 // Item Text
//                 Expanded(
//                   child: AnimatedDefaultTextStyle(
//                     duration: const Duration(milliseconds: 300),
//                     style: GoogleFonts.poppins(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       decoration: item.purchased
//                           ? TextDecoration.lineThrough
//                           : TextDecoration.none,
//                       color: item.purchased ? Colors.grey[600] : Colors.black87,
//                     ),
//                     child: Text(item.name),
//                   ),
//                 ),
//
//                 // Action Buttons
//                 Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     _buildActionButton(
//                       icon: Icons.edit_rounded,
//                       color: Colors.blue.shade600,
//                       onPressed: () => _showEditDialog(item),
//                     ),
//                     const SizedBox(width: 8),
//                     _buildActionButton(
//                       icon: Icons.delete_rounded,
//                       color: Colors.red.shade600,
//                       onPressed: () => _showDeleteConfirmation(item),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildActionButton({
//     required IconData icon,
//     required Color color,
//     required VoidCallback onPressed,
//   }) {
//     return Material(
//       color: color.withOpacity(0.1),
//       borderRadius: BorderRadius.circular(8),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(8),
//         onTap: onPressed,
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Icon(icon, size: 18, color: color),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildEnhancedAddItemField() {
//     return Container(
//       margin: const EdgeInsets.all(12),
//       padding: const EdgeInsets.all(4),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: TextField(
//               controller: _controller,
//               decoration: InputDecoration(
//                 hintText: 'Add grocery item...',
//                 hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//               ),
//               style: GoogleFonts.poppins(),
//             ),
//           ),
//           Container(
//             margin: const EdgeInsets.all(4),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.lightGreen.shade600,
//                   Colors.lightGreen.shade800,
//                 ],
//               ),
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Material(
//               color: Colors.transparent,
//               child: InkWell(
//                 borderRadius: BorderRadius.circular(12),
//                 onTap: () {
//                   final text = _controller.text.trim();
//                   if (text.isNotEmpty) {
//                     addGroceryItem(text);
//                     _controller.clear();
//
//                     // Add a small animation feedback
//                     _fabAnimationController.reverse().then((_) {
//                       _fabAnimationController.forward();
//                     });
//                   }
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 20,
//                     vertical: 12,
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       const Icon(Icons.add_rounded, color: Colors.white, size: 20),
//                       const SizedBox(width: 4),
//                       Text(
//                         'Add',
//                         style: GoogleFonts.poppins(
//                           fontWeight: FontWeight.w600,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showEditDialog(GroceryItem item) {
//     final TextEditingController editController =
//     TextEditingController(text: item.name);
//
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       pageBuilder: (context, animation1, animation2) {
//         return Container();
//       },
//       transitionBuilder: (context, animation1, animation2, widget) {
//         return Transform.scale(
//           scale: animation1.value,
//           child: Opacity(
//             opacity: animation1.value,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: Text(
//                 'Edit Item',
//                 style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//               ),
//               content: TextField(
//                 controller: editController,
//                 decoration: InputDecoration(
//                   labelText: 'Item name',
//                   labelStyle: GoogleFonts.poppins(),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                 ),
//                 style: GoogleFonts.poppins(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     'Cancel',
//                     style: GoogleFonts.poppins(color: Colors.grey[600]),
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.lightGreen.shade700,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     final newName = editController.text.trim();
//                     if (newName.isNotEmpty) {
//                       editGroceryItem(item.id, newName);
//                     }
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Save',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
//
//   void _showDeleteConfirmation(GroceryItem item) {
//     showGeneralDialog(
//       context: context,
//       barrierDismissible: true,
//       barrierLabel: '',
//       pageBuilder: (context, animation1, animation2) {
//         return Container();
//       },
//       transitionBuilder: (context, animation1, animation2, widget) {
//         return Transform.scale(
//           scale: animation1.value,
//           child: Opacity(
//             opacity: animation1.value,
//             child: AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               title: Text(
//                 'Delete Item',
//                 style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//               ),
//               content: Text(
//                 'Are you sure you want to delete "${item.name}"?',
//                 style: GoogleFonts.poppins(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text(
//                     'Cancel',
//                     style: GoogleFonts.poppins(color: Colors.grey[600]),
//                   ),
//                 ),
//                 ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade600,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                   ),
//                   onPressed: () {
//                     deleteGroceryItem(item.id);
//                     Navigator.pop(context);
//                   },
//                   child: Text(
//                     'Delete',
//                     style: GoogleFonts.poppins(
//                       color: Colors.white,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//       transitionDuration: const Duration(milliseconds: 300),
//     );
//   }
// }
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery_list_app/Providers/user_provider.dart';
import 'package:grocery_list_app/UI/login_screen.dart';
import 'package:grocery_list_app/UI/purchased_history_ui.dart';
import '../Providers/state_notfier_provider.dart';
import '../classes/grocery_details_class.dart';

class GroceryScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<GroceryScreen> createState() => _GroceryScreenState();
}

class _GroceryScreenState extends ConsumerState<GroceryScreen>
    with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late AnimationController _fabAnimationController;
  late AnimationController _headerAnimationController;
  late Animation<double> _fabScaleAnimation;
  late Animation<Offset> _headerSlideAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize animations
    _fabScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabAnimationController,
      curve: Curves.elasticOut,
    ));

    _headerSlideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.bounceOut,
    ));

    // Start animations
    _headerAnimationController.forward();
    _fabAnimationController.forward();
  }

  @override
  void dispose() {
    _fabAnimationController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProfileAsync = ref.watch(userProfileProvider);
    final groceriesAsync = ref.watch(groceryListProvider);
    final filter = ref.watch(filterProvider);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: SlideTransition(
          position: _headerSlideAnimation,
          child: Text(
            'Grocery List',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.lightGreen.shade600,
                Colors.lightGreen.shade800,
              ],
            ),
          ),
        ),
        actions: [
          _buildAnimatedIconButton(
            icon: filter == FilterType.purchased
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            tooltip: filter == FilterType.purchased
                ? 'Show Unpurchased'
                : 'Show Purchased',
            onPressed: () {
              ref.read(filterProvider.notifier).state =
              filter == FilterType.purchased
                  ? FilterType.unpurchased
                  : FilterType.purchased;
            },
          ),
          _buildAnimatedIconButton(
            icon: Icons.history_rounded,
            tooltip: "Purchase History",
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      PurchasedHistoryScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          _buildAnimatedIconButton(
            icon: Icons.logout_rounded,
            tooltip: "Logout",
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return SlideTransition(
                      position: animation.drive(
                        Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                            .chain(CurveTween(curve: Curves.easeInOut)),
                      ),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (profile) {
          if (profile == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: Opacity(
                          opacity: value,
                          child: Icon(
                            Icons.person_off_outlined,
                            size: 80,
                            color: Colors.grey[400],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Please log in to see your groceries',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }

          return groceriesAsync.when(
            data: (fullList) {
              final filteredItems = ref.watch(filteredGroceryListProvider(fullList));

              return Column(
                children: [
                  // Animated Header Cards
                  SlideTransition(
                    position: _headerSlideAnimation,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.lightGreen.shade800,
                            Colors.transparent,
                          ],
                          stops: const [0.0, 1.0],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 20),
                        child: Row(
                          children: [
                            _buildAnimatedInfoCard(
                              "Pending",
                              fullList.where((item) => !item.purchased).length,
                              Colors.orange.shade50,
                              Colors.orange.shade700,
                              Icons.shopping_cart_rounded,
                              0,
                            ),
                            const SizedBox(width: 12),
                            _buildAnimatedInfoCard(
                              "Completed",
                              fullList.where((item) => item.purchased).length,
                              Colors.green.shade50,
                              Colors.green.shade700,
                              Icons.check_circle_rounded,
                              1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // List with Enhanced Animations
                  Expanded(
                    child: filteredItems.isEmpty
                        ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 1000),
                            builder: (context, value, child) {
                              return Transform.scale(
                                scale: value,
                                child: Opacity(
                                  opacity: value,
                                  child: Icon(
                                    Icons.shopping_basket_outlined,
                                    size: 80,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "No items yet",
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Add your first grocery item below",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    )
                        : AnimationLimiter(
                      child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 400),
                            child: SlideAnimation(
                              verticalOffset: 50,
                              child: FadeInAnimation(
                                child: _buildEnhancedListItem(item, index, profile!),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  // Enhanced Add Item Field
                  ScaleTransition(
                    scale: _fabScaleAnimation,
                    child: _buildEnhancedAddItemField(profile!),
                  ),
                ],
              );
            },
            loading: () => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, child) {
                      return Transform.rotate(
                        angle: value * 2 * 3.14159,
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.lightGreen.shade700),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Loading your groceries...",
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            error: (err, _) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Oops! Something went wrong',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Error: $err',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(seconds: 1),
                builder: (context, value, child) {
                  return Transform.rotate(
                    angle: value * 2 * 3.14159,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(Colors.lightGreen.shade700),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Text(
                "Loading your profile...",
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Profile Error',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Error: $e',
                style: GoogleFonts.poppins(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedIconButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: IconButton(
            icon: Icon(icon),
            tooltip: tooltip,
            onPressed: () {
              // Add a small bounce animation
              setState(() {});
              onPressed();
            },
          ),
        );
      },
    );
  }

  Widget _buildAnimatedInfoCard(
      String title,
      int count,
      Color bgColor,
      Color textColor,
      IconData icon,
      int index,
      ) {
    return Expanded(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 600 + (index * 200)),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: Card(
              elevation: 8,
              color: bgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: textColor.withOpacity(0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(icon, color: textColor, size: 24),
                          const SizedBox(width: 8),
                          Text(
                            title,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TweenAnimationBuilder<int>(
                        tween: IntTween(begin: 0, end: count),
                        duration: const Duration(milliseconds: 1000),
                        builder: (context, value, child) {
                          return Text(
                            '$value',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 28,
                              color: textColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEnhancedListItem(GroceryItem item, int index, dynamic profile) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Material(
        elevation: item.purchased ? 2 : 4,
        borderRadius: BorderRadius.circular(16),
        color: item.purchased ? Colors.grey[100] : Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => togglePurchased(item.id, !item.purchased, profile),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.purchased
                    ? Colors.green.withOpacity(0.3)
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                // Animated Checkbox
                GestureDetector(
                  onTap: () => togglePurchased(item.id, !item.purchased, profile),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: item.purchased
                          ? Colors.green.shade600
                          : Colors.transparent,
                      border: Border.all(
                        color: item.purchased
                            ? Colors.green.shade600
                            : Colors.grey.shade400,
                        width: 2,
                      ),
                    ),
                    child: item.purchased
                        ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),

                // Item Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 300),
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          decoration: item.purchased
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: item.purchased ? Colors.grey[600] : Colors.black87,
                        ),
                        child: Text(item.name),
                      ),
                      if (item.purchased && item.purchasedDate != null)
                        Text(
                          'Purchased on: ${item.purchasedDate}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),

                // Action Buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildActionButton(
                      icon: Icons.edit_rounded,
                      color: Colors.blue.shade600,
                      onPressed: () => _showEditDialog(item, profile),
                    ),
                    const SizedBox(width: 8),
                    _buildActionButton(
                      icon: Icons.delete_rounded,
                      color: Colors.red.shade600,
                      onPressed: () => _showDeleteConfirmation(item, profile),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }

  Widget _buildEnhancedAddItemField(dynamic profile) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Add grocery item...',
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              style: GoogleFonts.poppins(),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.lightGreen.shade600,
                  Colors.lightGreen.shade800,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final text = _controller.text.trim();
                  if (text.isNotEmpty) {
                    final newItem = GroceryItem(
                      id: '',
                      name: text,
                      purchased: false,
                      purchasedDate: null,
                    );
                    addGrocery(newItem, profile);
                    _controller.clear();

                    // Add a small animation feedback
                    _fabAnimationController.reverse().then((_) {
                      _fabAnimationController.forward();
                    });
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        'Add',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(GroceryItem item, dynamic profile) {
    final TextEditingController editController =
    TextEditingController(text: item.name);

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Edit Item',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: TextField(
                controller: editController,
                decoration: InputDecoration(
                  labelText: 'Item name',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.lightGreen.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    final newName = editController.text.trim();
                    if (newName.isNotEmpty) {
                      updateGrocery(item.id, {'name': newName}, profile);
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }

  void _showDeleteConfirmation(GroceryItem item, dynamic profile) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, animation1, animation2) {
        return Container();
      },
      transitionBuilder: (context, animation1, animation2, widget) {
        return Transform.scale(
          scale: animation1.value,
          child: Opacity(
            opacity: animation1.value,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Text(
                'Delete Item',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Text(
                'Are you sure you want to delete "${item.name}"?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(color: Colors.grey[600]),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    deleteGrocery(item.id, profile);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Delete',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}