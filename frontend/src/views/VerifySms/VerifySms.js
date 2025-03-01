import { mapActions, mapGetters } from 'vuex'
import config from '../../../public/config'

export default {
  name: 'verify-sms',
  components: {},
  props: [],
  data () {
    return {
      url: null,
      isMobile: /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
    }
  },
  computed: {
    ...mapGetters([
      'smsVerificationStatus'
    ])
  },
  mounted () {
    this.validateSms({
      userId: this.$route.query.userId,
      verificationCode: this.$route.query.verificationCode
    })
  },
  methods: {
    ...mapActions([
      'validateSms',
      'saveState',
      'setDoubleName',
      'setScope',
      'setAppId',
      'setAppPublicKey',
      'loginUser'
    ]),
    openApp () {
      if (this.isMobile) {
        var url = `${config.deeplink}login/?state=${encodeURIComponent(this.state)}`
        if (this.scope) url += `&scope=${encodeURIComponent(this.scope)}`
        if (this.appId) url += `&appId=${encodeURIComponent(this.appId)}`
        if (this.appPublicKey) url += `&appPublicKey=${encodeURIComponent(this.appPublicKey)}`
        window.open(url)
      }
    }
  },
  watch: {
    smsVerificationStatus (val) {
      console.log(`smsVerificationStatus`, val)
      console.log(`this.$route.query`, this.$route.query)
      if (!val.checking && val.checked && val.valid) {
        console.log(`Log in`)
        this.saveState({
          _state: this.$route.query.state,
          redirectUrl: window.atob(this.$route.query.redirecturl)
        })

        this.setDoubleName(this.$route.query.doublename)

        this.setScope(this.$route.query.scope || null)
        this.setAppId(this.$route.query.appid || null)
        this.setAppPublicKey(this.$route.query.publickey || null)

        var isMobile = /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)
        this.loginUser({ mobile: isMobile, firstTime: false })
        this.$router.push({ name: 'login', params: { again: true } })
      }
    }
  }
}
