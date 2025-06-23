import 'dart:math' as math;

class SimpleMathParser {
  String _expression;
  final Map<String, num> _vars;
  int _pos = 0;

  SimpleMathParser(this._expression, this._vars);

  double evaluate() {
    _vars.forEach((key, val) {
      _expression = _expression.replaceAll(key, val.toString());
    });
    _expression = _expression.replaceAll(' ', '');

    _pos = 0;
    try {
      return _parseExpression();
    } catch (e) {
      throw FormatException('Ошибка вычисления: $e');
    }
  }

  double _parseExpression() {
    double result = _parseTerm();
    while (_pos < _expression.length) {
      String op = _peek();
      if (op == '+' || op == '-') {
        _pos++;
        double term = _parseTerm();
        result = (op == '+') ? result + term : result - term;
      } else {
        break;
      }
    }
    return result;
  }

  double _parseTerm() {
    double result = _parseFactor();
    while (_pos < _expression.length) {
      String op = _peek();
      if (op == '*' || op == '/') {
        _pos++;
        double factor = _parseFactor();
        if (op == '*') {
          result *= factor;
        } else {
          if (factor == 0) {
            throw FormatException('Деление на ноль');
          }
          result /= factor;
        }
      } else {
        break;
      }
    }
    return result;
  }

  double _parseFactor() {
    double result = _parsePower();
    while (_pos < _expression.length) {
      String op = _peek();
      if (op == '^') {
        _pos++;
        double power = _parseFactor();
        result = math.pow(result, power).toDouble();
      } else {
        break;
      }
    }
    return result;
  }

  double _parsePower() {
    // Обработка унарного минуса
    if (_peek() == '-') {
      _pos++;
      return -_parsePower();
    }

    String char = _peek();
    if (char == '(') {
      _pos++;
      double result = _parseExpression();
      if (_peek() != ')') {
        throw FormatException('Не хватает закрывающей скобки');
      }
      _pos++;
      return result;
    } else {
      return _parseNumber();
    }
  }

  double _parseNumber() {
    StringBuffer numStr = StringBuffer();
    while (_pos < _expression.length) {
      String char = _peek();
      if (char == '.' || _isDigit(char)) {
        numStr.write(char);
        _pos++;
      } else {
        break;
      }
    }
    if (numStr.isEmpty) {
      throw FormatException('Ожидалось число. Позиция: ${_pos}, символ: ${_expression[_pos]}');
    }
    return double.parse(numStr.toString());
  }

  String _peek() {
    if (_pos >= _expression.length) return '';
    return _expression[_pos];
  }

  bool _isDigit(String char) {
    return char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
           char.codeUnitAt(0) <= '9'.codeUnitAt(0);
  }
}
