package tests;
 

import org.junit.Test;

import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.OAuth2AccessToken;
import com.github.scribejava.core.model.OAuthRequest;
import com.github.scribejava.core.model.Response;
import com.github.scribejava.core.model.Verb;
import com.github.scribejava.core.oauth.OAuth20Service;

public class VimeoTest {

	
	//@Test
	public void test() throws Exception {
		
		// API 키를 사용하여 서비스 생성 > API 비밀키 지정하여 서비스 객체를 생성.
		OAuth20Service service = new ServiceBuilder("9f42e2684346344c9325c02061f8adec4b8efb24")
                .apiSecret("EGs1pMXuHyDsCHNqfcWi1UZdi61UFTRTdkLDkJq+mO/osQzxdR0/5/HirEkqmwzxY8ftxMZQsVm8zmDWJnedweM5MvG/AYraeKrQG35NlDb7MDussh5DtUXVRAUe49XG")
		        .build(VimeoApi.instance()); 
		
		// 호울 서비스 API 
		String url = String.format("https://api.vimeo.com/videos/%s/privacy/domains/%s", 287030364, "inkium.podo-namu.co.kr" );
		System.out.println(url);
		
		OAuthRequest request = new OAuthRequest(Verb.DELETE, url);
		
		//OAuth 인증을 위하여 매 서비스 호출마다 인증 토큰을 세팅하여 API 를 호출. 
		OAuth2AccessToken accessToken = new OAuth2AccessToken("8ee180080897a086670b7b9f41b2b892");
        service.signRequest(accessToken, request);
        Response response = service.execute(request);
        System.out.println("Got it! Lets see what we found...");
        System.out.println(response.getHeaders());
        System.out.println(response.getCode());
        System.out.println(response.getBody());
	}

}
