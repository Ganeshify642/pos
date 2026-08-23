import 'dart:io';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../data/database/app_database.dart';
import '../../data/db_types.dart';
import '../../providers/menu_provider.dart';
import '../../utils/app_colors.dart';
import '../../utils/formatters.dart';
import '../../widgets/empty_state.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MenuProvider>().loadAll();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: canPop
          ? AppBar(
              title: const Text('Menu'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _tabController.index == 0
                      ? _showCategoryForm(context)
                      : _showItemForm(context),
                ),
              ],
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            if (!canPop)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 8, 0),
                child: Row(
                  children: [
                    Text(
                      'Menu',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add, color: AppColors.primary),
                      onPressed: () => _tabController.index == 0
                          ? _showCategoryForm(context)
                          : _showItemForm(context),
                    ),
                  ],
                ),
              ),
            TabBar(
              controller: _tabController,
              tabs: const [Tab(text: 'Categories'), Tab(text: 'Items')],
              labelColor: AppColors.primary,
              unselectedLabelColor:
                  theme.colorScheme.onSurface.withValues(alpha: 0.6),
              indicatorColor: AppColors.primary,
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 15),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _CategoriesTab(
                      onAddCategory: () => _showCategoryForm(context)),
                  _ItemsTab(onAddItem: () => _showItemForm(context)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCategoryForm(BuildContext context) {
    final nameController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
            16, 16, 16, MediaQuery.of(_).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Category',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (nameController.text.trim().isNotEmpty) {
                    context
                        .read<MenuProvider>()
                        .addCategory(nameController.text.trim());
                    Navigator.pop(_);
                  }
                },
                child: const Text('Add Category'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemForm(BuildContext context, [Item? item]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => _ItemForm(item: item),
    );
  }
}

class _CategoriesTab extends StatelessWidget {
  final VoidCallback onAddCategory;
  const _CategoriesTab({required this.onAddCategory});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    if (menuProvider.categories.isEmpty) {
      return EmptyState(
        icon: Icons.category_outlined,
        title: 'No categories',
        subtitle: 'Add your first menu category',
        actionLabel: 'Add Category',
        onAction: onAddCategory,
      );
    }
    return ListView.builder(
      itemCount: menuProvider.categories.length,
      itemBuilder: (_, i) {
        final cat = menuProvider.categories[i];
        final itemCount = menuProvider.itemsByCategory(cat.id).length;
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: Text(
              cat.name[0],
              style: const TextStyle(
                  color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
          title: Text(cat.name),
          subtitle: Text('$itemCount items'),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            onPressed: () => context.read<MenuProvider>().deleteCategory(cat.id),
          ),
        );
      },
    );
  }
}

class _ItemsTab extends StatelessWidget {
  final VoidCallback onAddItem;
  const _ItemsTab({required this.onAddItem});

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final items = menuProvider.items;

    if (items.isEmpty) {
      return EmptyState(
        icon: Icons.restaurant_menu_outlined,
        title: 'No items',
        subtitle: 'Add your menu items',
        actionLabel: 'Add Item',
        onAction: onAddItem,
      );
    }
    return Column(
      children: [
        // Search
        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            decoration: const InputDecoration(
              hintText: 'Search items...',
              prefixIcon: Icon(Icons.search),
              isDense: true,
            ),
            onChanged: (q) => context.read<MenuProvider>().setSearchQuery(q),
          ),
        ),
        Expanded(
          child: ListView.separated(
            itemCount: menuProvider.filteredItems.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (_, i) {
              final item = menuProvider.filteredItems[i];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                    '${AppFormatters.currency(item.sellingPrice)}  •  ${menuProvider.categories.where((Category c) => c.id == item.categoryId).map((Category c) => c.name).firstOrNull ?? ''}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Switch.adaptive(
                      value: item.isAvailable,
                      onChanged: (v) => context
                          .read<MenuProvider>()
                          .toggleItemAvailability(item.id, v),
                      activeColor: AppColors.accent,
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, size: 20),
                      onPressed: () =>
                          context.read<MenuProvider>().deleteItem(item.id),
                    ),
                  ],
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: item.imageUrl != null
                      ? Image.file(
                          File(item.imageUrl!),
                          width: 42,
                          height: 42,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _itemIconPlaceholder(item),
                        )
                      : _itemIconPlaceholder(item),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _itemIconPlaceholder(Item item) {
    return Container(
      width: 42,
      height: 42,
      color: item.isAvailable
          ? AppColors.primary.withValues(alpha: 0.12)
          : AppColors.textMuted.withValues(alpha: 0.12),
      child: Icon(
        Icons.restaurant_outlined,
        color: item.isAvailable ? AppColors.primary : AppColors.textMuted,
        size: 20,
      ),
    );
  }
}

class _ItemForm extends StatefulWidget {
  final Item? item;
  const _ItemForm({this.item});

  @override
  State<_ItemForm> createState() => _ItemFormState();
}

class _ItemFormState extends State<_ItemForm> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _costController = TextEditingController();
  final _descController = TextEditingController();
  int? _selectedCategoryId;
  String? _imagePath;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.item != null) {
      _nameController.text = widget.item!.name;
      _priceController.text = '${widget.item!.sellingPrice}';
      _costController.text = '${widget.item!.costPrice}';
      _descController.text = widget.item!.description;
      _selectedCategoryId = widget.item!.categoryId;
      _imagePath = widget.item!.imageUrl;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _costController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final xFile = await _picker.pickImage(
      source: source,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (xFile != null && mounted) {
      setState(() => _imagePath = xFile.path);
    }
  }

  void _showImageSourcePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(_);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(_);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_imagePath != null)
              ListTile(
                leading: const Icon(Icons.delete_outline, color: Colors.red),
                title: const Text('Remove Photo',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(_);
                  setState(() => _imagePath = null);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = context.watch<MenuProvider>();
    final isEdit = widget.item != null;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 20, 16, MediaQuery.of(context).viewInsets.bottom + 20),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(isEdit ? 'Edit Item' : 'Add Item',
                style: theme.textTheme.titleMedium),
            const SizedBox(height: 14),

            // Image picker
            Center(
              child: GestureDetector(
                onTap: _showImageSourcePicker,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.07),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.25),
                        width: 1.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _imagePath != null
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(File(_imagePath!), fit: BoxFit.cover),
                            Positioned(
                              bottom: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(Icons.edit,
                                    size: 14, color: Colors.white),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate_outlined,
                                size: 32,
                                color: AppColors.primary.withValues(alpha: 0.7)),
                            const SizedBox(height: 6),
                            Text('Add Photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.primary.withValues(alpha: 0.7),
                                )),
                          ],
                        ),
                ),
              ),
            ),

            const SizedBox(height: 14),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Item Name *'),
              autofocus: !isEdit,
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _selectedCategoryId,
              decoration: const InputDecoration(labelText: 'Category *'),
              items: menuProvider.categories
                  .map((Category c) => DropdownMenuItem<int>(
                      value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedCategoryId = v),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                        labelText: 'Selling Price ₹ *'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _costController,
                    decoration: const InputDecoration(
                        labelText: 'Cost Price ₹'),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descController,
              decoration:
                  const InputDecoration(labelText: 'Description'),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isEmpty ||
                      _selectedCategoryId == null) {
                    return;
                  }
                  final companion = ItemsTableCompanion(
                    categoryId: Value(_selectedCategoryId!),
                    name: Value(_nameController.text.trim()),
                    sellingPrice: Value(
                        double.tryParse(_priceController.text) ?? 0),
                    costPrice: Value(
                        double.tryParse(_costController.text) ?? 0),
                    description: Value(_descController.text),
                    imageUrl: Value(_imagePath),
                  );
                  if (isEdit) {
                    context
                        .read<MenuProvider>()
                        .updateItem(widget.item!.id, companion);
                  } else {
                    context.read<MenuProvider>().addItem(companion);
                  }
                  Navigator.pop(context);
                },
                child: Text(isEdit ? 'Save Changes' : 'Add Item'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
