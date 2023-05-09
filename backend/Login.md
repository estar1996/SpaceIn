## 로그인 구현에 대한 정보를 정리

> <hr>



### 0. 실제 프로젝트에서 수정할 부분

- application.properties

```properties
#resources.application.properties

#spring.datasource.url, spring.datasource.username 등 프로젝트에 맞게 설정

#social google login 부분
oauth2.google.client-id=175677411828-eq9lrrmt0kvs3n6l5se48ql06bh9ie2o.apps.googleusercontent.com
oauth2.google.client-secret=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
oauth2.google.redirect-uri=http://localhost:8080/login/oauth2/code/google
#해당 부분을 우주인 앱에 발급된 코드로 수정해야함.
```

- social login의 첫 단계에서 사용되는 링크 수정

   현재 커밋에는 테스트 용으로, 직접 만든 테스트용 앱의 주소 `https://accounts.google.com/o/oauth2/auth?client_id=175677411828-eq9lrrmt0kvs3n6l5se48ql06bh9ie2o.apps.googleusercontent.com&redirect_uri=http://localhost:8080/login/oauth2/code/google&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile` 를 사용하고 있지만,

  

  실제로는 우주인 앱의 CLIENT_ID 그리고 배포에 따라 수정된 REDIRECT_URI 를 삽입해야 한다. 

  `https://accounts.google.com/o/oauth2/auth?client_id=CLIENT_ID&redirect_uri=REDIRECT_URI&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile`

- 테스트용 API 삭제

  현재, helloController에 권한 있는 사용자만 POST할 수 있도록 테스트용 API가 작성되어 있다.

  (`http://localhost:8080/hello/start`) 이며, 헤더에 `Authentication`: `Bearer {JWT}` 가 들어가 있는 경우에만 POST 요청을 통해, request body의 parameter로 받은 {name: `"name"`}을 다시 리턴하도록 설계되어 있다. 테스트용 API이니 삭제할 것

  같은 링크에 GET 요청을 보내면 , 권한 없이도 "로그인 하세요" 라는 응답을 받을 수 있다.

  

  해당 API는 테스트용 코드니, securityConfig에서도 지워줄 것.

### 1. 프론트에서 해야 할 작업

![스프링-17](./loginlogic.jpg)



#### 1. 구글 로그인

프론트) 정해진 주소, `https://accounts.google.com/o/oauth2/auth?client_id=CLIENT_ID&redirect_uri=REDIRECT_URI&response_type=code&scope=https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile`

으로 요청을 보낸다. 그러면 구글 로그인 화면이 뜨게 되는데, 해당 구글 아이디로 로그인한다.



##### 응답

1. DB에 있는, 즉 회원가입이 된 아이디로 로그인된 경우

   `{"token":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrc2o5NzA3MTRAZ21haWwuY29tIiwiaWF0IjoxNjgzNjA4NTMxLCJleHAiOjE2ODM2MTY1MzEsInJvbGVzIjoicm9sZXMiLCJhdXRoIjoiTUVNQkVSIn0.NOQjqyNVPS446BOpCuFh6dilAXpqaWIPLorbIkiXoiY",`

   `"refreshToken":"eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrc2o5NzA3MTRAZ21haWwuY29tIiwiaWF0IjoxNjgzNjA4NTMxLCJleHAiOjE2ODM2ODg1MzF9.zwq1ws3ODW2aqIjisYYdijn59aSVyWXDu9JKPIg2eto"}`

   과 같은 응답을 받는다. flutter의 secureStorage에 해당 토큰값을 저장해두고, 추후 권한이 필요한 API 요청이 필요할 때마다 **리퀘스트 헤더에** `Authorization`:`Bearer ${token}` **값을 담아서 보내면 된다.** (앱 완성 전엔, 테스트를 위해 hello/start에 요청을 보내보는것도 좋다.)

   (token은 실제 권한을 상태성 없이 저장할 수 있는 토큰이고, refreshToken은 token보다 만료기한이 긴 토큰으로서 토큰이 만료된 경우 refreshToken을 통해 token을 재발급할 수 있도록 합니다.)

2. DB에 없는 아이디로 로그인한 경우

   401 응답을 반환한다. 

   프론트에서 해당 응답을 반환받은 경우, 해당 구글 계정에 대해 최초 1회 회원가입을 실시한다	

   - 회원가입의 경우, `user/signup/` 으로 POST 요청을 보낸다.

   - headers: X

   - body:  JSON 형태로 보낸다. (혹시 JSON으로 전송하는것이 어렵고 다른형태로 전송이 필요하면 말씀해주세요., 플러터가 굴러가는방식에 대해 잘 모름)

     ```json
     {
         "email": `email`
         "userNickname": `userNickname`
     }
     ```

     이후, 이메일/닉네임이 중복되지 않으면 가입된다. (DB에 추가됨)

     - 이메일 중복 시: 400 Bad Request, "이미 등록된 이메일입니다."
     - 닉네임 중복 시, 400 Bad Request, "이미 사용 중인 이메일입니다."

     해당 POST 요청이 성공하고 나면 해당 아이디로 로그인할 수 있다. 

     - 가입 성공 시, 200 OK, "사용자가 등록되었습니다."

     (해당 로직 구현을 위한 회원가입 페이지 만들어 주시면 감사하겠습니다.)

​	

#### 2. 리프레쉬 토큰 재발급

만약, 올바른 API 요청을 보내도 토큰이 만료되었으면 401 Unauthorized, `Access token expired` 응답을 반환받게된다.

해당 응답을 반환받았을 경우, 리프레쉬 토큰을 통해 Access Token을 재발급 받으면 된다. 

재발급을 위해 필요한 API는 `/user/updatetoken` 로, **POST 요청**을 보내면 된다.



- headers:

  ```json
  {
  	refreshToken: `refreshToken`
  }
  ```

- body: X

  

refreshToken은 accessToken 탈취에 대비해 만들어진 토큰으로, accessToken보다 기간이 길지만 로그인에 필요한 정보는 없고, DB에 리프레쉬 토큰을 저장해놓고 재발급 요청시 DB에 존재하는지 대조해보기 때문에, 만약 탈취되었을 경우 DB에서 삭제를 통해 재발급을 방지할 수 있다.

refreshToken을 받게 되면, 1) 유효성을 검증하고, 2) DB에 저장된 refreshToken과 정보를 대조해 올바른 refreshToken이면 : 새로운 accessToken과, 새로운 refreshToken을 반환한다. 

- 데이터베이스에 해당 refreshToken의 정보가 없는 경우
  - 401 UnAuthorized {"refreshToken","notExist"} 응답

- refreshToken의 기간마저 만료된 경우
  - 401 UnAuthorized, {"refreshToken","expired"} 응답

- 기타 다른 오류에 대해서는 아직 구현하지 않았음

- 만약 올바른 RefreshToken이 온 경우,

  - response body에 와 같은 응답이 옴,

    ```json
    {
        "newRefreshToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrc2o5NzA3MTRAZ21haWwuY29tIiwiaWF0IjoxNjgzNjA1MzM0LCJleHAiOjE2ODM2ODUzMzR9.tLQbzgpg--LzQlye6526t4Gc3tHjxu7jqMaXG-tifuE",
        "accessToken": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJrc2o5NzA3MTRAZ21haWwuY29tIiwiaWF0IjoxNjgzNjA1MzM0LCJleHAiOjE2ODM2MTMzMzQsInJvbGVzIjoicm9sZXMiLCJhdXRoIjoiTUVNQkVSIn0.ObOpNqsdIgNHEsKjhvKcRkjM3WN2REzQwJ8n6UYgWS0"
    }
    ```

    

flutter secure storage에 해당 데이터 저장해 놓고 다시 사용하면 됨.