import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _alamatController = TextEditingController();
  final _bioController = TextEditingController();
  

  File? _selectedImage;
  bool _isLoading = false;
  bool _isUploading = false;
  String? _currentPhotoUrl;

  final ImagePicker _imagePicker = ImagePicker();
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return;

      final response = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', user.id)
          .maybeSingle();

      if (response != null) {
        _namaController.text = response['nama_lengkap'] ?? '';
        _alamatController.text = response['alamat'] ?? '';
        _bioController.text = response['bio'] ?? '';
       
        _currentPhotoUrl = response['foto_profil'];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_selectedImage == null) return _currentPhotoUrl;

    setState(() {
      _isUploading = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return null;

      final fileExtension = _selectedImage!.path.split('.').last;
      final fileName = 'profile_${user.id}_${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

      // Upload image to Supabase Storage
      await _supabase.storage
          .from('profile_pictures')
          .upload(fileName, _selectedImage!);

      // Get public URL
      final String imageUrl = _supabase.storage
          .from('profile_pictures')
          .getPublicUrl(fileName);

      return imageUrl;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading image: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return null;
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('User not authenticated');
      }

      // Upload image first if selected
      final String? photoUrl = await _uploadImage();

      // Prepare profile data
      final profileData = {
        'user_id': user.id,
        'nama_lengkap': _namaController.text.trim(),
        'alamat': _alamatController.text.trim(),
        'bio': _bioController.text.trim(),
        
        'foto_profil': photoUrl ?? _currentPhotoUrl,
        'updated_at': DateTime.now().toIso8601String(),
      };

      // **SOLUSI UPSERT YANG BENAR**
      await _upsertProfileData(profileData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profil berhasil disimpan!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving profile: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // **METHOD UPSERT YANG AMAN**
  Future<void> _upsertProfileData(Map<String, dynamic> profileData) async {
    try {
      // Coba update dulu jika data sudah ada
      final updateResponse = await _supabase
          .from('user_profiles')
          .update(profileData)
          .eq('user_id', profileData['user_id'])
          .select();

      // Jika update tidak mengubah baris apapun (data belum ada), maka insert
      if (updateResponse.isEmpty) {
        await _supabase
            .from('user_profiles')
            .insert(profileData)
            .select();
      }
    } catch (e) {
      // Jika ada error, coba dengan approach yang berbeda
      await _alternativeUpsert(profileData);
    }
  }

  // **METHOD ALTERNATIF UNTUK UPSERT**
  Future<void> _alternativeUpsert(Map<String, dynamic> profileData) async {
    try {
      // Gunakan upsert dengan onConflict
      await _supabase
          .from('user_profiles')
          .upsert(
        profileData,
        onConflict: 'user_id', // Pastikan kolom ini ada di constraint unique
      );
    } catch (e) {
      // Jika masih error, cek dulu apakah data exist
      final existingData = await _supabase
          .from('user_profiles')
          .select()
          .eq('user_id', profileData['user_id'])
          .maybeSingle();

      if (existingData != null) {
        // Update existing data
        await _supabase
            .from('user_profiles')
            .update(profileData)
            .eq('user_id', profileData['user_id']);
      } else {
        // Insert new data
        await _supabase
            .from('user_profiles')
            .insert(profileData);
      }
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _alamatController.dispose();
    _bioController.dispose();
   
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          "Edit Profil Petani",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green[700],
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
        actions: [
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading && !_isUploading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Photo Upload Section
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "Foto Profil",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green[300]!,
                                    width: 3,
                                  ),
                                ),
                                child: CircleAvatar(
                                  radius: 55,
                                  backgroundColor: Colors.green[50],
                                  backgroundImage: _selectedImage != null
                                      ? FileImage(_selectedImage!)
                                      : (_currentPhotoUrl != null && _currentPhotoUrl!.isNotEmpty)
                                          ? NetworkImage(_currentPhotoUrl!)
                                          : null,
                                  child: _selectedImage == null &&
                                          (_currentPhotoUrl == null || _currentPhotoUrl!.isEmpty)
                                      ? Icon(
                                          Icons.agriculture_rounded,
                                          size: 40,
                                          color: Colors.green[400],
                                        )
                                      : null,
                                ),
                              ),
                              if (_isUploading)
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: _isUploading ? null : _pickImage,
                              icon: const Icon(Icons.camera_alt_rounded),
                              label: const Text("Pilih Foto"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.green[700]!),
                              ),
                            ),
                          ),
                          if (_selectedImage != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Foto baru dipilih",
                                style: TextStyle(
                                  color: Colors.green[600],
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Form Fields
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Informasi Petani",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Nama Lengkap
                          _buildTextField(
                            controller: _namaController,
                            label: "Nama Lengkap",
                            hint: "Masukkan nama lengkap Anda",
                            icon: Icons.person_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Nama lengkap harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          // Lokasi Kebun
                          _buildTextField(
                            controller: _alamatController,
                            label: "Lokasi Kebun",
                            hint: "Masukkan lokasi kebun Anda",
                            icon: Icons.location_on_rounded,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Lokasi kebun harus diisi';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                        
                         

                          // Bio/Tentang Petani
                          _buildTextField(
                            controller: _bioController,
                            label: "Tentang Petani ",
                            hint: "Ceritakan tentang diri Anda dan pengalaman bertani tomat...",
                            icon: Icons.description_rounded,
                            maxLines: 4,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Action Buttons
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Save Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _saveProfile,
                              icon: _isLoading
                                  ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    )
                                  : const Icon(Icons.save_rounded),
                              label: Text(
                                _isLoading ? "Menyimpan..." : "Simpan Perubahan",
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Cancel Button
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              onPressed: _isLoading
                                  ? null
                                  : () {
                                      Navigator.pop(context);
                                    },
                              child: const Text(
                                "Batal",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.green[700],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                side: BorderSide(color: Colors.green[700]!),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.green[700],
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.green[700]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[700]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.green[300]!),
            ),
          ),
        ),
      ],
    );
  }
}