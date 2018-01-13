<section id="contact" class="gray-section contact">
    <div class="container">
        <div class="row m-b-lg g-mt-100">
            <div class="col-lg-3 col-lg-offset-3">
                <address>
                    <strong><span class="navy">${ CommunityContextHelper.getConfigService().getApplicationProperty("website.company.name", "Company Name") }</span></strong><br>
                    ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.company.address", "Company Address") }<br>
                    <abbr title="Phone">P:</abbr> ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.company.phone", "Company Phone") }
                </address>
            </div>
            <div class="col-lg-4">
                <p class="text-color g-font-size-20">
                    이 사이트는 여러 오픈소스 기술을 기반으로 개발되었습니다.
                </p>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-8 col-lg-offset-2 text-center m-t-lg m-b-lg">
                <p><strong>© 2018 ${ CommunityContextHelper.getConfigService().getApplicationProperty("website.company.name", "Company Name") }</strong>
                <br></p>
            </div>
        </div>
    </div>
</section>