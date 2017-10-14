var prompt = require('prompt');

const questionMessage = 'Seleccionar operacion: (0) Promedio pares, (1) Remplaza impares de V2 en pares de V1:\n';
const divError = 'Error division por cero.\n';
const errorMessage = 'Error, ingrese 0 o 1.\n';

const vec0 = [ 3, 1, 2, 4, 7, 6, -9999 ];

const vec1 = [ 9, 4, 7, 5, 3, 2, 8, 6, -9999 ];

function main() {

  // Print question for user input
  // Get integer from user for operation type
  prompt.message = questionMessage;
  prompt.start();

  prompt.get([ 'Operacion' ], (err, result) => {
    const operation = parseInt(result['Operacion'])
    if (
      err ||
      operation != 0 &&
      operation != 1
    ) {
      console.log(errorMessage);
      return setTimeout(() => {
        main();
      });
    }

    if (operation == 0) {
      averagePairs();
    } else {
      replacePairsByOdds();
    }
  })
}

function averagePairs() {
  let average = 0;
  let count = 0;
  let i = 0;

  while (vec0[i] !== -9999) {
    if (division(vec0[i], 2).residuo !== 0) {
      i++;
      continue;
    }
    average += vec0[i];
    count++;
    i++;
  }

  average = division(average, count).unidades;

  vec0[vec0.length - 1] = average;
  vec0.push(-9999);

  printVector(vec0);
}

function replacePairsByOdds() {
  if (
    vec0.length < 1 ||
    vec1.length < 2
  ) {
    return;
  }

  let i = 0;
  while (
    vec0[i] !== -9999 &&
    vec1[i+1] !== -9999
  ) {
    if (division(i, 2).residuo !== 0) {
      i++
      continue;
    }
    vec0[i] = vec1[i+1];
    i++;
  }

  printVector(vec0);
}

function printVector(vector) {
  console.log(vector.slice(0, -1))
}

function division(dividendo, divisor) {
  let signo = 1;
  let unidades = 0;
  if (divisor === 0) {
    throw divError;
  }
  if (dividendo < 0) {
    signo *= -1;
  }
  if (divisor < 0) {
    signo *= -1;
  }
  while (dividendo >= divisor) {
    dividendo -= divisor;
    unidades++;
  }
  unidades *= signo;
  return {
    unidades,
    residuo: dividendo,
  }
}

main()
