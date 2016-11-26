import java.io.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class t14632152 {
    public static void main(String[] args) throws IOException{
        FileReader file = new FileReader(args[0]);
        BufferedReader br = new BufferedReader(file);

        String linea = null;
        while ((linea = br.readLine()) != null){
            String tipo = tipificador(linea);
            if (tipo == "float"){
                Float dato = Float.valueOf(linea);
                System.out.format(java.util.Locale.US, "%s => %s (%.20f)\n", linea, dato.getClass().getSimpleName(), dato);
            }
            else if (tipo == "fraccion"){
                // lo hago con double para el caso limite 100000000000000/10 que es un long
                // pero con float lo interpreta como 9999... y entonces lo interpreta como float y no cm long
                String[] datos = linea.split("/");
                Double numerador = Double.valueOf(datos[0]);
                Double denominador = Double.valueOf(datos[1]);
                Double dato = numerador / denominador;
                if (numerador % denominador == 0){
                    Long dato_c = Math.round(dato);
                    String linea_c = Long.toString(dato_c);
                    tipificador_entero(linea_c, linea);
                    // System.out.format(java.util.Locale.US, "%s => %s (%d)\n", linea, dato_c.getClass().getSimpleName(), dato_c);
                }
                else {
                    Float dato_f = Float.valueOf(datos[0]) / Float.valueOf(datos[1]);
                    System.out.format(java.util.Locale.US, "%s => %s (%.20f)\n", linea, dato_f.getClass().getSimpleName(), dato_f);
                }
            }
            else if (tipo == "entero"){
                tipificador_entero(linea, "");
            }
            else if (tipo == "string"){
                tipificador_string(linea);
            }
        }
        file.close();
    }

    public static String tipificador(String linea){
        Pattern p_float = Pattern.compile("^(\\-)?\\d+\\.\\d+$");
        Matcher m_float = p_float.matcher(linea);
        Pattern p_fracc = Pattern.compile("^(\\-)?\\d+/\\d+$");
        Matcher m_fracc = p_fracc.matcher(linea);
        Pattern p_enter = Pattern.compile("^\\d+$");
        Matcher m_enter = p_enter.matcher(linea);
        if (m_float.matches()){
            return "float";
        }
        if (m_fracc.matches()){
            return "fraccion";
        }
        if (m_enter.matches()){
            return "entero";
        }
        else {
            return "string";
        }
    }

    public static void tipificador_entero(String linea, String f){
        Long dato = Long.valueOf(linea);
        if (-128 <= dato && dato <= 127){
            Byte dato_b = Byte.valueOf(linea);
            System.out.format("%s => %s", f.length() > 0 ? f : linea, dato_b.getClass().getSimpleName());
            System.out.format(f.length() > 0 ? " (%d)\n"  : "\n", dato_b);
        }
        else if (-32768 <= dato && dato <= 32767){
            Short dato_s = Short.valueOf(linea);
            System.out.format("%s => %s", f.length() > 0 ? f : linea, dato_s.getClass().getSimpleName());
            System.out.format(f.length() > 0 ? " (%d)\n"  : "\n", dato_s);
        }
        else if (-2147483648 <= dato && dato <= 2147483647){
            Integer dato_i = Integer.valueOf(linea);
            System.out.format("%s => %s", f.length() > 0 ? f : linea, dato_i.getClass().getSimpleName());
            System.out.format(f.length() > 0 ? " (%d)\n"  : "\n", dato_i);
        }
        else {
            System.out.format("%s => %s", f.length() > 0 ? f : linea, dato.getClass().getSimpleName());
            System.out.format(f.length() > 0 ? " (%d)\n"  : "\n", dato);
        }
    }

    public static void tipificador_string(String linea){
        if (linea.length() == 1){
            Character dato_ch = linea.charAt(0);
            System.out.format("%s => %s\n", linea, dato_ch.getClass().getSimpleName());
        }
        else {
            System.out.format("%s => %s\n", linea, linea.getClass().getSimpleName());
        }
    }
}
