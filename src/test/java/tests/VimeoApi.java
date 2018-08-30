package tests;

import com.github.scribejava.core.builder.api.DefaultApi20;

public class VimeoApi extends DefaultApi20 {

	protected VimeoApi() {
    }

    private static class InstanceHolder {
        private static final VimeoApi INSTANCE = new VimeoApi();
    }

    public static VimeoApi instance() {
        return InstanceHolder.INSTANCE;
    }


/*
	@Override
	public String getAccessTokenEndpoint() {
		return "http://vimeo.com/oauth/access_token";
	}

	@Override
	public String getRequestTokenEndpoint() {
		return "http://vimeo.com/oauth/request_token";
	}

	@Override
	public String getAuthorizationUrl(Token requestToken) {
		return String.format(AUTHORIZATION_URL, requestToken.getToken());
	}

*/

	@Override
	public String getAccessTokenEndpoint() {
		return "https://vimeo.com/oauth/access_token";
	}

	@Override
	protected String getAuthorizationBaseUrl() { 
		return "https://vimeo.com/oauth/authorize";
	}

}
