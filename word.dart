import 'dart:io';
import 'dart:math';

void main() 
{
  // Eng(영어), Kor(한국어) 리스트 선언
  List<String> Eng = [];
  List<String> Kor = [];
  List<String> Wrong = [];
  int start = -1, end = -1, length = -1;

  // 파일 경로 설정 (Project IDX 환경에서는 상대 경로 사용)
  String filePath1 = 'voca.txt', filePath2 = "voca_info.txt", filePath3 = "voca_wrong.txt";
  var File1 = File(filePath1), File2 = File(filePath2), File3 = File(filePath3);

  // 문제 풀었던 시작점 및 끝점 읽어오기
  try 
  {
    // 파일을 동기적으로 읽어서 첫 줄 가져오기
    List<String> lines = File2.readAsLinesSync();
    if (lines.isNotEmpty) 
    {
      List<String> parts = lines[0].split(',');
      String t1 = parts[0].trim(), t2 = parts[1].trim();
      start = int.parse(t1);
      end = int.parse(t2);
      length = end - start + 1;
    }
  } 
  catch (e) 
  {
    print('word_info.txt를 읽는 중 오류 발생: $e');
  }

  // 영단어 및 뜻 읽어오기
  try 
  {
    // 파일을 동기적으로 읽어오기
    List<String> lines = File1.readAsLinesSync();
    for (int i = start; i <= end; i++) 
    {
      String line = lines[i];
      List<String> parts = line.split('//');
      if (parts.length == 2) 
      { // "//"가 정확히 한 번 있는 경우만 처리
        Eng.add(parts[0].trim()); // 앞쪽 문자열 (영어)
        Kor.add(parts[1].trim()); // 뒤쪽 문자열 (한국어)
      }
    }
  } 
  catch (e) 
  {
    print('eng_words.txt를 읽는 중 오류 발생: $e');
  }

  print("영단어 퀴즈를 시작하겠습니다!");
  print("start : ${start}, end : ${end}");
  var random = Random();

  for (int i = 0; i < length; i++) 
  {
    List<String> answers = [Kor[i]];
    String right_answer = Kor[i];
    int count = 0;
    late int right_number;
    while (count < 4) 
    {
      int index = random.nextInt(length);
      if (!(answers.contains(Kor[index]))) {
        answers.add(Kor[index]);
        count++;
      }
    }

    // 정답 리스트를 랜덤하게 섞기
    answers.shuffle();

    print("\n${Eng[i]}");
    print("이에 해당하는 단어의 뜻을 고르시오.");
    for (int j = 0; j < answers.length; j++) 
    {
      print("${j + 1}. ${answers[j]} ");
      if(answers[j] == right_answer)
      {
        right_number = j + 1;
      } 
    }

    // 사용자 입력 받기
    String? answerInput = stdin.readLineSync();
    int? num_input = int.tryParse(answerInput ?? "");
    if (num_input == right_number) 
    {
      print("정답입니다!");
      
    } 
    else 
    {
      print("틀렸습니다!");
      print("${Eng[i]}는 ${right_answer}입니다.");
      Wrong.add("${Eng[i]}//${Kor[i]}\n");
    }
  }

  // 다음 범위 설정
  start = end + 1;
  end = start + 99;

  // voca_info.txt에 새 범위를 저장
  try 
  {
    File2.writeAsStringSync("${start}, ${end}\n");
    File2.writeAsStringSync("능률보카 수능 실전편", mode: FileMode.append);
  } 
  catch (e) 
  {
    print('voca_info.txt를 저장하는 중 오류 발생: $e');
  }

  // 틀린 단어 저장
  try 
  {
    for (int i = 0; i < Wrong.length; i++) 
    {
      String contents = Wrong[i];
      File3.writeAsStringSync(contents, mode: FileMode.append);
    }
  }
  catch (e) 
  {
    print('voca_wrong.txt를 저장하는 중 오류 발생: $e');
  }
}