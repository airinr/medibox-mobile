class Validators {
  Validators._();

  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Field tidak boleh kosong';
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return 'Format email tidak valid';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Nomor telepon tidak boleh kosong';
    }
    final phoneRegExp = RegExp(r'^\+?[\d\s\-]{10,15}$');
    if (!phoneRegExp.hasMatch(value.trim())) {
      return 'Format nomor telepon tidak valid';
    }
    return null;
  }

  static String? Function(String?) minLength(int min) {
    return (String? value) {
      if (value == null || value.length < min) {
        return 'Minimal $min karakter';
      }
      return null;
    };
  }
}
