# Data Vault – Departman Dosya Sunucusu

Bu proje, üniversite ortamında departman dosya sunucusunun yönetimi için
örnek bir mimari ve betik seti sunar.

## Amaç

- Departman klasörlerini (finans, ik vb.) merkezi bir dizin altında toplamak
- Grup temelli erişim kontrolü, SGID ve ACL kullanarak yetki yönetimi
- Betik ve dokümantasyonun Git ile versiyonlanması

## Git Yapısı

- \main\ dalı her zaman stabil sürümü temsil eder.
- Yeni özellikler \eature/*\ dallarında geliştirilir.
- Commit mesaj formatı:

  - \eat: ...\  yeni özellikler
  - \ix: ...\   hata düzeltmeleri
  - \docs: ...\  dokümantasyon güncellemeleri
  - \chore: ...\ bakım/temizlik işleri

Örnek:

- \eat: finans ve ik departman klasörlerini oluştur- \docs: acl-plan.md dokümantasyonunu ekle
## Lisans

Bu proje, GNU GPLv3 lisansı ile lisanslanmıştır.

Bu sayede:

- Projeyi inceleyebilir, değiştirebilir ve paylaşabilirsiniz.
- Ancak değiştirilmiş sürümleri dağıtırsanız,
  aynı lisansla (GPLv3) açık kaynak olarak paylaşmanız gerekir.
- Proje, ticari bir ürünün içine kapalı kaynak olarak gömülemez.

Bu lisans özellikle üniversite ortamında geliştirilen projelerin
fork edilse bile açık kaynak olarak kalmasını garanti altına almak
için tercih edilmiştir.
