import 'package:flutter/material.dart';

class CategoryColors {
  // 🎨 MAPA DE CORES FIXAS
  // Ajuste as chaves (Strings) abaixo para serem IDÊNTICAS às suas categorias no Hive.
  static final Map<String, Color> _fixedColors = {
    // Essenciais / Urgentes
    'Alimentação': Color(0xFFFF7043), // Laranja Queimado (Comida/Atenção)
    'Saúde': Color(0xFF26A69A), // Verde Teal (Bem-estar/Médico)
    'Moradia': Color(0xFF5C6BC0), // Índigo (Estabilidade/Casa)
    // Movimento / Serviços
    'Transporte': Color(0xFF42A5F5), // Azul (Movimento/Veículo)
    'Educação': Color(0xFFFFA726), // Âmbar/Amarelo (Conhecimento)
    // Estilo de Vida / Outros
    'Lazer': Color(0xFFAB47BC), // Roxo (Diversão/Criatividade)
    'Outros': Color(0xFF78909C), // Cinza Azulado (Neutro)
  };

  /// Retorna a cor associada à categoria.
  static Color getColor(String category) {
    // 1. Verifica se existe no mapa fixo (correspondência exata)
    if (_fixedColors.containsKey(category)) {
      return _fixedColors[category]!;
    }

    // 2. Tenta verificar removendo espaços ou capitalização (opcional, para segurança)
    // Ex: "alimentação" vs "Alimentação"
    final keyCaseInsensitive = _fixedColors.keys.firstWhere(
      (k) => k.toLowerCase() == category.toLowerCase(),
      orElse: () => '',
    );

    if (keyCaseInsensitive.isNotEmpty) {
      return _fixedColors[keyCaseInsensitive]!;
    }

    // 3. Fallback: Se criar uma categoria nova no futuro que não está no mapa,
    // gera uma cor automática vibrante para não quebrar o app.
    return _generateFallbackColor(category);
  }

  /// Gerador de cor de segurança (caso apareça uma categoria desconhecida)
  static Color _generateFallbackColor(String category) {
    final hash = category.hashCode;
    const double goldenRatioConjugate = 0.61803398875;
    final double hue = (hash * goldenRatioConjugate) % 1.0;

    final hslColor = HSLColor.fromAHSL(1.0, hue * 360.0, 0.6, 0.6);
    return Color(hslColor.toColor().value);
  }
}
