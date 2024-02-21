import { fileIo } from '@kit.CoreFileKit'
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { promptAction } from '@kit.ArkUI';

@Entry
@Component
struct FileCopy {
  @State
  list: Resource[] = [
    $r("app.media.001"),
    $r("app.media.002"),
    $r("app.media.003"),
    $r("app.media.004"),
    $r("app.media.005"),
    $r("app.media.006"),
    $r("app.media.007"),
    $r("app.media.008"),
    $r("app.media.009"),
    $r("app.media.010")
  ]


  // 保存沙箱图片到相册
  async saveImgToAssets() {
    try {
      let index = 0
      while (index < this.list.length) {
        let context = getContext();
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
        // Creating a Media File
        let uri = await phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpg');
        // Open the created media file and read the local file and convert it to ArrayBuffer for easy filling.
        let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE);
        let buffer = getContext(this).resourceManager.getMediaContentSync(this.list[index].id);
        // Write the read ArrayBuffer to the new media file.
        let writeLen = await fileIo.write(file.fd, buffer.buffer);
        await fileIo.close(file);
        index++
      }
      promptAction.showToast({ message: '下载成功' })

    } catch (err) {
      AlertDialog.show({ message: err.message })
    }
  }

  build() {
    Column({ space: 10 }) {
      Row() {
        SaveButton()
          .onClick((event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              this.saveImgToAssets()
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      GridRow({ columns: 2 }) {
        ForEach(this.list, (item: string) => {
          GridCol() {
            Image(item)
              .height(150)
              .height(150)
              .borderRadius(4)
          }
          .margin({
            top: 10
          })
        })
      }

    }

  }
}