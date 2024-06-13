package site.beemil.samanthaV2.controller.bot;

import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.util.*;

@Component
@CrossOrigin
@RestController
@RequestMapping("/bot/*")
public class BotRestController {
    ///Field
    private static final Logger logger = LoggerFactory.getLogger(BotRestController.class);
    private final Properties config = new Properties();

    ///Constructor
    public BotRestController(@Value("classpath:application-${spring.profiles.active}.properties") Resource configFile) {
        try {
            if (configFile.exists()) {
                config.load(configFile.getInputStream());
                System.out.println("application-" + System.getProperty("spring.profiles.active") + ".properties 파일이 로드되었습니다.");

            } else {
                System.err.println("application-" + System.getProperty("spring.profiles.active") + ".properties 파일이 존재하지 않습니다.");
            }
        } catch (IOException e) {
            logger.error("application-" + System.getProperty("spring.profiles.active") + ".properties 파일을 불러 오는데 실패했습니다.", e);
        }
    }

    // NAVER Cloud ChatBot
    @RequestMapping("chat")
    public ResponseEntity<String> chatBot(@RequestBody String text) {
        // 최종 결과값 리턴시 사용할 인스턴스 선언
        JSONObject chatbotMessage;

        String apiUrl = config.getProperty("api.bot.url");
        String secretKey = config.getProperty("api.bot.client.secret");

        // 사용자 질문 텍스트 Request
        String message = getReqMessage(text);

        logger.info("입력 질문: " + message);

        String encodeBase64String = makeSignature(message, secretKey);

        try {
            HttpURLConnection con = (HttpURLConnection) new URL(apiUrl).openConnection();

            con.setDoOutput(true);
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; charset=UTF-8");
            con.setRequestProperty("X-NCP-CHATBOT_SIGNATURE", encodeBase64String);

            OutputStream outputStream = con.getOutputStream();

            outputStream.write(message.getBytes(StandardCharsets.UTF_8));
            outputStream.flush();
            outputStream.close();

            BufferedReader br;
            String decodedString;

            int responseCode = con.getResponseCode();

            if (responseCode == 200) {  // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));

            } else {                    // 오류 발생
                JSONObject errorResponse = new JSONObject();
                errorResponse.put("error", "API request failed with response code: " + responseCode);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse.toString());
            }
            StringBuilder response = new StringBuilder();

            while ((decodedString = br.readLine()) != null) {
                response.append(decodedString);
            }
            br.close();

            // 챗봇 텍스트 결과 출력
            logger.info("챗봇 응답: " + response);
            chatbotMessage = new JSONObject(response.toString());

        } catch (Exception e) {
            logger.error("Failed to perform chatbot request", e);

            // 예외 처리 후 바로 반환
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to perform chatbot request");
        }
        return ResponseEntity.ok(chatbotMessage.toString());
    }
    public static String makeSignature(String message, String secretKey) {
        try {
            byte[] secretKeyBytes = secretKey.getBytes(StandardCharsets.UTF_8);

            SecretKeySpec signingKey = new SecretKeySpec(secretKeyBytes, "HmacSHA256");
            Mac mac = Mac.getInstance("HmacSHA256");
            mac.init(signingKey);

            byte[] rawHmac = mac.doFinal(message.getBytes(StandardCharsets.UTF_8));
            return Base64.getEncoder().encodeToString(rawHmac);

        } catch (Exception e) {
            throw new RuntimeException("Failed to generate signature", e);
        }
    }
    public static String getReqMessage(String text) {
        /// 최종 결과값 리턴시 사용할 변수 선언
        String requestBody = "";

        // userId 랜덤 생성
        String userId = UUID.randomUUID().toString();

        try {
            JSONObject obj = new JSONObject();
            long timestamp = new Date().getTime();

            System.out.println("::");
            logger.info("대화 시간: {}", timestamp);

            obj.put("version", "v2");
            obj.put("userId", userId);
            obj.put("timestamp", timestamp);

            JSONObject bubbles_obj = new JSONObject();

            bubbles_obj.put("type", "text");

            JSONObject data_obj = new JSONObject();

            data_obj.put("description", text);
            bubbles_obj.put("data", data_obj);

            JSONArray bubbles_array = new JSONArray();

            bubbles_array.put(bubbles_obj);
            obj.put("bubbles", bubbles_array);

            if (Objects.equals(text, "동영상 보여줘")) {
                obj.put("event", "open");

            } else {
                obj.put("event", "send");
            }
            requestBody = obj.toString();

        } catch (Exception e) {
            logger.error("Failed to create the request message", e);
        }
        return requestBody;
    }

    // NAVER Cloud SpeechToText
    @CrossOrigin
    @RequestMapping("stt")
    public StringBuffer speechToText(@RequestPart("audio") MultipartFile audioFile) throws Exception {
        // 최종 결과값 리턴 시 사용할 인스턴스 선언
        StringBuffer response = new StringBuffer();

        String apiUrl = config.getProperty("api.stt.url");
        String clientId = config.getProperty("api.stt.client.id");
        String clientSecret = config.getProperty("api.stt.client.secret");

        try {
            HttpURLConnection con = (HttpURLConnection) new URL(apiUrl).openConnection();

            con.setDoOutput(true);
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Length", String.valueOf(audioFile.getSize()));
            con.setRequestProperty("Content-Type", "application/octet-stream");
            con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
            con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);

            //Client에서 넘어온 바이너리 음성 데이터 타입 변환
            InputStream inputStream = audioFile.getInputStream();

            // 네이버 API 로 바이너리 음성 파일 전송 준비
            OutputStream outputStream = con.getOutputStream();

            byte[] buffer = new byte[4096];
            int bytesRead = -1;

            while ((bytesRead = inputStream.read(buffer)) != -1) {

                outputStream.write(buffer, 0, bytesRead);
            }

            //네이버 API 로 바이너리 음성 파일 전송
            outputStream.flush();
            outputStream.close();
            inputStream.close();

            BufferedReader br;
            String inputLine;

            int responseCode = con.getResponseCode();

            if(responseCode == 200) {   // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream(), StandardCharsets.UTF_8));

            } else {					// 오류 발생
                System.out.println("error!!!!!!! responseCode= " + responseCode);
                br = new BufferedReader(new InputStreamReader(con.getErrorStream(), StandardCharsets.UTF_8));
            }

            while ((inputLine = br.readLine()) != null) {
                response.append(inputLine);
            }
            br.close();

            // 음성변환 텍스트 결과 출력
            System.out.println("::");
            logger.info("음성 변환 결과: {}", response);

        }	catch (Exception e) {
            logger.error("Failed to perform speech-to-text conversion", e);
        }
        return response;
    }

    // 페이지 내비게이션 서비스
    @CrossOrigin
    @RequestMapping("navi")
    public ResponseEntity<Map<String, String[]>> pageNavigation(@RequestBody(required = false) Map<String, String[]> data) throws Exception {
        if (data != null && data.containsKey("url")) {
            String[] urls = data.get("url");

            if (urls != null && urls.length > 0) {
                String[] responseData = new String[]{urls[0]};
                return ResponseEntity.ok().body(Collections.singletonMap("url", responseData));
            }
        }
        return ResponseEntity.badRequest().build();
    }

    /*ddd*/
/* NAVER Cloud TextToSpeech(요금 이슈로 인해 사용 안 함)
    @RequestMapping("tts")
    public static ResponseEntity<byte[]> textToSpeech(@RequestBody String tts) throws Exception {

    String apiUrl = config.getProperty("api.tts.url");
    String clientId = config.getProperty("api.tts.client.id");
    String clientSecret = config.getProperty("api.tts.client.secret");

    // 챗봇 응답 텍스트 Request
    String text = URLEncoder.encode(tts, "UTF-8");
    String postParams = "speaker=ngoeun&volume=0&speed=0&pitch=0&format=mp3&text=" + text;

    try {
        HttpURLConnection con = (HttpURLConnection) new URL(apiUrl).openConnection();

        con.setDoOutput(true);
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        con.setRequestProperty("X-NCP-APIGW-API-KEY-ID", clientId);
        con.setRequestProperty("X-NCP-APIGW-API-KEY", clientSecret);

        DataOutputStream wr = new DataOutputStream(con.getOutputStream());

        wr.writeBytes(postParams);
        wr.flush();
        wr.close();

        int responseCode = con.getResponseCode();

        BufferedReader br;
        String date = Long.valueOf(new Date().getTime()).toString();

        if(responseCode==200) { // 정상 호출

            InputStream is = con.getInputStream();

            int read = 0;
            byte[] bytes = new byte[1024];

            ByteArrayOutputStream bos = new ByteArrayOutputStream();

            while ((read =is.read(bytes)) != -1) {

                bos.write(bytes, 0, read);
            }
            is.close();

            byte[] byteData = bos.toByteArray();
            HttpHeaders headers = new HttpHeaders();

            headers.setContentType(MediaType.parseMediaType("audio/mpeg"));
            headers.setContentLength(byteData.length);
            headers.setContentDispositionFormData("attachment", date + ".mp3");

            ResponseEntity<byte[]> response = new ResponseEntity<byte[]>(byteData, headers, HttpStatus.OK);

            System.out.println("::");
            System.out.println("챗봇음성: " + response);

            return response;

            } else {  // 오류 발생

                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
                String inputLine;
                StringBuilder response = new StringBuilder();

                while ((inputLine = br.readLine()) != null) {

                    response.append(inputLine);
                }

                br.close();
                System.out.println(response.toString());
            }

        } catch (Exception e) {

            System.out.println(e);
        }
        return null;
    }*/
}