import 'dart:convert';

class Parametro {
  int concepto;
  String parametro;

  Parametro(
    this.concepto,
    this.parametro,
   );

  Parametro.map(dynamic obj){
    this.concepto = obj['concepto'];
    this.parametro = obj['parametro'];
  }

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "parametro": parametro,
  };
}

class Valor {
  int concepto;
  double valor;

  Valor(
    this.concepto,
    this.valor
  );

  Valor.map(dynamic obj){
    this.concepto = obj['concepto'];
    this.valor = obj['valor'];
  }

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "valor": valor,
  };
}

class Contador {
  int concepto;
  String contador;

  Contador(
      this.concepto,
      this.contador
      );

  Contador.map(dynamic obj){
    this.concepto = obj['concepto'];
    this.contador = obj['contador'];
  }

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "contador": contador,
  };
}


class Formula {
  int concepto;
  String debito;
  String credito;
  String contador;
  int cantidad;
  int indicador;
  String sentencia;
  int redondeo;

  Formula(
      this.concepto,
      this.debito,
      this.credito,
      this.contador,
      this.cantidad,
      this.indicador,
      this.sentencia,
      this.redondeo,
      );

  Formula.map(dynamic obj){
    this.concepto = obj['concepto'];
    this.debito = obj['debito'];
    this.credito = obj['credito'];
    this.contador = obj['contador'];
    this.cantidad = obj['cantidad'];
    this.indicador = obj['indicador'];
    this.sentencia = obj['sentencia'];
    this.redondeo= obj['redondeo'];
  }

  Map<String, dynamic> toMap() => {
    "concepto": concepto,
    "debito": debito,
    "credito": credito,
    "contador": contador,
    "cantidad": cantidad,
    "indicador": indicador,
    "sentencia": sentencia,
    "redondeo": redondeo,
  };
}

