import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TeamMemberCard extends StatefulWidget {
  final Map<String, dynamic> member;

  const TeamMemberCard({
    super.key,
    required this.member,
  });

  @override
  State<TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<TeamMemberCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // Deteksi ukuran layar untuk responsivitas
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;
    
    // Ukuran avatar lebih kecil
    final double avatarSize = isSmallScreen ? 50 : 55;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBCCBB9).withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Bagian atas (always visible)
          GestureDetector(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Foto profil kecil
                  CircleAvatar(
                    radius: avatarSize / 2,
                    backgroundImage: AssetImage(widget.member['image'] as String),
                    onBackgroundImageError: (_, __) {},
                  ),
                  const SizedBox(width: 12),
                  
                  // Informasi
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.member['name'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isSmallScreen ? 14 : 15,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF191C1E),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.member['role'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: isSmallScreen ? 11 : 12,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF006E2D),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Icon indikator expand/collapse
                  Icon(
                    _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: const Color(0xFF006E2D).withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
          
          // Bagian detail (expanded)
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 300),
            crossFadeState: _isExpanded ? CrossFadeState.showFirst : CrossFadeState.showSecond,
            firstChild: Container(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  
                  // Skill tags
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: (widget.member['skills'] as List<String>).map((skill) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (widget.member['color'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          skill,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: widget.member['color'] as Color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 12),
                  
                  // Email
                  Row(
                    children: [
                      Icon(Icons.email_outlined, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.member['email'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Telepon
                  Row(
                    children: [
                      Icon(Icons.phone_android, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        widget.member['phone'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Lokasi
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Text(
                        widget.member['location'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  
                  // Pendidikan
                  Row(
                    children: [
                      Icon(Icons.school, size: 14, color: Colors.grey.shade600),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          widget.member['education'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Tentang
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.member['about'] as String,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        height: 1.4,
                        color: const Color(0xFF3D4A3D),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}