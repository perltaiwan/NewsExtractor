package NewsExtractor::Extractor;
use Moo;
extends 'NewsExtractor::TXExtractor';

use Mojo::Transaction::HTTP;
use Mojo::URL;
use Types::Standard qw(InstanceOf);
use NewsExtractor::CSSRuleSet;
use NewsExtractor::CSSExtractor;
use NewsExtractor::JSONLDExtractor;
use NewsExtractor::GenericExtractor;
use NewsExtractor::SiteSpecificExtractor::www_rvn_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_allnews_tw;
use NewsExtractor::SiteSpecificExtractor::www_peopo_org;
use NewsExtractor::SiteSpecificExtractor::www_ntdtv_com;
use NewsExtractor::SiteSpecificExtractor::www_ksnews_com_tw;
use NewsExtractor::SiteSpecificExtractor::news_tvbs_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_taipeitimes_com;
use NewsExtractor::SiteSpecificExtractor::www_rti_org_tw;
use NewsExtractor::SiteSpecificExtractor::www_bcc_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_setn_com;
use NewsExtractor::SiteSpecificExtractor::news_tnn_tw;
use NewsExtractor::SiteSpecificExtractor::turnnewsapp_com;
use NewsExtractor::SiteSpecificExtractor::news_cts_com_tw;
use NewsExtractor::SiteSpecificExtractor::talk_ltn_com_tw;
use NewsExtractor::SiteSpecificExtractor::estate_ltn_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_upmedia_mg;
use NewsExtractor::SiteSpecificExtractor::ctee_com_tw;
use NewsExtractor::SiteSpecificExtractor::news_ebc_net_tw;
use NewsExtractor::SiteSpecificExtractor::newnet_tw;
use NewsExtractor::SiteSpecificExtractor::www_thestandnews_com;
use NewsExtractor::SiteSpecificExtractor::www_epochtimes_com;
use NewsExtractor::SiteSpecificExtractor::www_ttv_com_tw;
use NewsExtractor::SiteSpecificExtractor::news_ttv_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_idn_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_fountmedia_io;
use NewsExtractor::SiteSpecificExtractor::news_pts_org_tw;
use NewsExtractor::SiteSpecificExtractor::www_twreporter_org;
use NewsExtractor::SiteSpecificExtractor::new_ctv_com_tw;
use NewsExtractor::SiteSpecificExtractor::hk_crntt_com;
use NewsExtractor::SiteSpecificExtractor::hk_on_cc;
use NewsExtractor::SiteSpecificExtractor::www_hkcna_hk;
use NewsExtractor::SiteSpecificExtractor::www_hkcnews_com;
use NewsExtractor::SiteSpecificExtractor::www_xinhuanet_com;
use NewsExtractor::SiteSpecificExtractor::news_cctv_com;
use NewsExtractor::SiteSpecificExtractor::m_news_cctv_com;
use NewsExtractor::SiteSpecificExtractor::focustaiwan_tw;
use NewsExtractor::SiteSpecificExtractor::newtalk_tw;
use NewsExtractor::SiteSpecificExtractor::www_digitimes_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_ustv_com_tw;
use NewsExtractor::SiteSpecificExtractor::www_mdnkids_com;
use NewsExtractor::SiteSpecificExtractor::www_nownews_com;
use NewsExtractor::SiteSpecificExtractor::www_penghutimes_com;
use NewsExtractor::SiteSpecificExtractor::www_aljazeera_com;
use NewsExtractor::SiteSpecificExtractor::www_bbc_com;
use NewsExtractor::SiteSpecificExtractor::yimedia_com_tw;
use NewsExtractor::SiteSpecificExtractor::UDN;
use NewsExtractor::SiteSpecificExtractor::ETtoday;
use NewsExtractor::SiteSpecificExtractor::ChinaTimes;

has extractor => (
    required => 0,
    is => 'lazy',
    isa => InstanceOf["NewsExtractor::CSSExtractor",
                      "NewsExtractor::JSONLDExtractor",
                      "NewsExtractor::SiteSpecificExtractor",
                      "NewsExtractor::GenericExtractor"],
    builder => 1,
    handles => [qw( headline dateline journalist content_text )],
);

use constant {
    SiteSpecificExtractorByHost => {
        'www.bbc.com' => 'NewsExtractor::SiteSpecificExtractor::www_bbc_com',
        'www.aljazeera.com' => 'NewsExtractor::SiteSpecificExtractor::www_aljazeera_com',
        'www.penghutimes.com' => 'NewsExtractor::SiteSpecificExtractor::www_penghutimes_com',
        'www.ustv.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_ustv_com_tw',
        'www.epochtimes.com' => 'NewsExtractor::SiteSpecificExtractor::www_epochtimes_com',
        'www.hkcnews.com' => 'NewsExtractor::SiteSpecificExtractor::www_hkcnews_com',
        'www.thestandnews.com' => 'NewsExtractor::SiteSpecificExtractor::www_thestandnews_com',
        'www.allnews.tw' => 'NewsExtractor::SiteSpecificExtractor::www_allnews_tw',
        'www.rvn.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_rvn_com_tw',
        'www.chinatimes.com' => 'NewsExtractor::SiteSpecificExtractor::ChinaTimes',
        'video.udn.com' => 'NewsExtractor::JSONLDExtractor',
        'www.ctwant.com' => 'NewsExtractor::JSONLDExtractor',
        'www.peopo.org' => 'NewsExtractor::SiteSpecificExtractor::www_peopo_org',
        'www.ntdtv.com' => 'NewsExtractor::SiteSpecificExtractor::www_ntdtv_com',
        'www.ksnews.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_ksnews_com_tw',
        'news.tvbs.com.tw' => 'NewsExtractor::SiteSpecificExtractor::news_tvbs_com_tw',
        'udn.com' => 'NewsExtractor::SiteSpecificExtractor::UDN',
        'stars.udn.com' => 'NewsExtractor::SiteSpecificExtractor::UDN',
        'money.udn.com' => 'NewsExtractor::SiteSpecificExtractor::UDN',
        'house.udn.com' => 'NewsExtractor::SiteSpecificExtractor::UDN',
        'opinion.udn.com' => 'NewsExtractor::SiteSpecificExtractor::UDN',
        'www.taipeitimes.com' => 'NewsExtractor::SiteSpecificExtractor::www_taipeitimes_com',
        'www.ettoday.net' => 'NewsExtractor::SiteSpecificExtractor::ETtoday',
        'star.ettoday.net' => 'NewsExtractor::SiteSpecificExtractor::ETtoday',
        'house.ettoday.net' => 'NewsExtractor::SiteSpecificExtractor::ETtoday',
        'health.ettoday.net' => 'NewsExtractor::SiteSpecificExtractor::ETtoday',
        'www.rti.org.tw' => 'NewsExtractor::SiteSpecificExtractor::www_rti_org_tw',
        'www.bcc.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_bcc_com_tw',
        'www.setn.com' => 'NewsExtractor::SiteSpecificExtractor::www_setn_com',
        'news.tnn.tw' => 'NewsExtractor::SiteSpecificExtractor::news_tnn_tw',
        'turnnewsapp.com' => 'NewsExtractor::SiteSpecificExtractor::turnnewsapp_com',
        'news.cts.com.tw' => 'NewsExtractor::SiteSpecificExtractor::news_cts_com_tw',
        'talk.ltn.com.tw' => 'NewsExtractor::SiteSpecificExtractor::talk_ltn_com_tw',
        'estate.ltn.com.tw' => 'NewsExtractor::SiteSpecificExtractor::estate_ltn_com_tw',
        'www.upmedia.mg' => 'NewsExtractor::SiteSpecificExtractor::www_upmedia_mg',
        'ctee.com.tw' => 'NewsExtractor::SiteSpecificExtractor::ctee_com_tw',
        'news.ebc.net.tw' => 'NewsExtractor::SiteSpecificExtractor::news_ebc_net_tw',
        'newnet.tw' => 'NewsExtractor::SiteSpecificExtractor::newnet_tw',
        'www.ttv.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_ttv_com_tw',
        'news.ttv.com.tw' => 'NewsExtractor::SiteSpecificExtractor::news_ttv_com_tw',
        'www.idn.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_idn_com_tw',
        'www.fountmedia.io' => 'NewsExtractor::SiteSpecificExtractor::www_fountmedia_io',
        'news.pts.org.tw' => 'NewsExtractor::SiteSpecificExtractor::news_pts_org_tw',
        'www.twreporter.org' => 'NewsExtractor::SiteSpecificExtractor::www_twreporter_org',
        'new.ctv.com.tw' => 'NewsExtractor::SiteSpecificExtractor::new_ctv_com_tw',
        'hk.crntt.com' => 'NewsExtractor::SiteSpecificExtractor::hk_crntt_com',
        'hk.on.cc' => 'NewsExtractor::SiteSpecificExtractor::hk_on_cc',
        'www.hkcna.hk' => 'NewsExtractor::SiteSpecificExtractor::www_hkcna_hk',
        'www.xinhuanet.com' => 'NewsExtractor::SiteSpecificExtractor::www_xinhuanet_com',
        'news.cctv.com' => 'NewsExtractor::SiteSpecificExtractor::news_cctv_com',
        'm.news.cctv.com' => 'NewsExtractor::SiteSpecificExtractor::m_news_cctv_com',
        'focustaiwan.tw' => 'NewsExtractor::SiteSpecificExtractor::focustaiwan_tw',
        'newtalk.tw' => 'NewsExtractor::SiteSpecificExtractor::newtalk_tw',
        'www.digitimes.com.tw' => 'NewsExtractor::SiteSpecificExtractor::www_digitimes_com_tw',
        'www.mdnkids.com' => 'NewsExtractor::SiteSpecificExtractor::www_mdnkids_com',
        'www.nownews.com' => 'NewsExtractor::SiteSpecificExtractor::www_nownews_com',
        'yimedia.com.tw' => 'NewsExtractor::SiteSpecificExtractor::yimedia_com_tw',
    },
    CSSRuleSetByHost => {
        'www.eventsinfocus.org' => {
            headline => 'h1.title > span',
            dateline => 'div.content time.datetime',
            journalist => 'div.content div.node__content div.clearfix.text-formatted > p:nth-child(1)',
            content_text => 'div.content article div.clearfix.text-formatted',
        },
        'www.5ch.com.tw' => {
            headline => 'h3.m-ti',
            dateline => 'div.more-about div.date',
            journalist => 'div.more-about div.reporter',
            content_text => 'div.text-edit',
        },
        'www.cw.com.tw' => {
            headline => 'div.article__head h1',
            dateline => 'div.article__detail > time',
            journalist => 'div.author--item > a',
            content_text => 'div.article__content',
        },
        'www.taiwannews.com.tw' => {
            headline => 'h1.article-title',
            dateline => 'div.article-date',
            journalist => 'div.article-author',
            content_text => 'article.article',
        },
        'www.enewstw.com' =>  {
            headline     => 'td.blog_title > strong',
            dateline     => 'td.blog_title tr:nth-child(2) > td.blog',
            journalist   => 'td.blog_title tr:nth-child(1) > td.blog',
            content_text => 'td.new_t p',
        },
        'www.storm.mg' =>  {
            headline     => 'h1#article_title',
            dateline     => 'span#info_time',
            journalist   => '#article_info_wrapper #author_block a.link_author > span.info_author',
            content_text => 'div#article_inner_wrapper > article:nth-child(1)',
        }
    }
};

sub _build_extractor {
    my ($self) = @_;
    my $url = $self->tx->req->url;
    my $host = $url->host;
    my $extractor;
    if (my $sel = CSSRuleSetByHost->{$host}) {
        $extractor = NewsExtractor::CSSExtractor->new(
            css_selector => NewsExtractor::CSSRuleSet->new(%$sel),
            tx => $self->tx
        );
    } elsif (my $extractor_class = SiteSpecificExtractorByHost->{$host}) {
        $extractor = $extractor_class->new( tx => $self->tx );
    } else {
        $extractor = NewsExtractor::GenericExtractor->new( tx => $self->tx );
    }
    return $extractor;
}

1;
