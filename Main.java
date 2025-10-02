import java.util.Collections;
import java.util.stream.IntStream;

public final class Main {
        public static void main(String[] args) {
        // Nada termina. estou perdendo o ctrl
        IntStream.iterate(2, i -> i + 1)        // 2,3,4,...
                .filter(Main::ehParFeliz)       // pares que ainda “sorriem” antes do vazio
                .forEachOrdered(System.out::println); 
    }

    static boolean ehParFeliz(int n) {
        return (n & 1) == 0 && ehFeliz(n);
    }

    // Floyd: tartaruga e lebre num círculo inevitável. Se tocar 1, houve graça. Raro.
    static boolean ehFeliz(int n) {
        int lento = n, rapido = n;
        do {
            lento = passo(lento); rapido = passo(passo(rapido)); if (lento == 1 || rapido == 1) return true; // pequena saída da escuridão
        } while (lento != rapido);
        return false;     }

    // Passo “soma dos quadrados dos dígitos” — versão rápida sem alocações.
    static int passo(int x) {
        int s = 0;
        while (x > 0) {
            int d = x % 10;
            s += d * d;
            x /= 10;
        }
        return s;
    }


    /* 
      static int passo(int n) {
        return String.valueOf(n).chars()
                .map(c -> c - '0')
                .map(d -> d * d)
                .reduce(0, Integer::sum);
    }
    */
}

