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

  @State
  list2: Resource[] = [
    $r("app.media.yellow"),
    $r("app.media.white"),
    $r("app.media.red"),
    $r("app.media.pink"),
    $r("app.media.orange"),
    $r("app.media.grey"),
    $r("app.media.green"),
    $r("app.media.girl"),
    $r("app.media.boy"),
    $r("app.media.blue"),
    $r("app.media.purple"),
    $r("app.media.blueness")
  ]

  @State
  list3: Resource[] = [
    $r("app.media.bb"),
  ]

  // 保存沙箱图片到相册
  async saveImgToAssets(
    list: Resource[],
    PhotoType: photoAccessHelper.PhotoType = photoAccessHelper.PhotoType.IMAGE,
    extendName: string = 'jpg'
  ) {
    try {
      let index = 0
      while (index < list.length) {
        let context = getContext();
        let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
        // Creating a Media File
        let uri = await phAccessHelper.createAsset(PhotoType, extendName);
        // Open the created media file and read the local file and convert it to ArrayBuffer for easy filling.
        let file = await fileIo.open(uri, fileIo.OpenMode.READ_WRITE);
        let buffer = getContext().resourceManager.getMediaContentSync(list[index].id);
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
      Row({space:5}) {
        SaveButton()
          .onClick((event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              this.saveImgToAssets(this.list)
            }
          })

        SaveButton()
          .onClick((event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              this.saveImgToAssets(this.list2)
            }
          })

        SaveButton()
          .onClick((event, result: SaveButtonOnClickResult) => {
            if (result === SaveButtonOnClickResult.SUCCESS) {
              this.saveImgToAssets(this.list3, photoAccessHelper.PhotoType.VIDEO, 'mp4')
            }
          })
      }
      .justifyContent(FlexAlign.Center)
      .width('100%')
      GridRow({ columns: 5 }) {
        ForEach(this.list, (item: string) => {
          GridCol() {
            Image(item)
              .width('100%')
              .borderRadius(4)
          }
          .margin({
            top: 10
          })
        })
      }
      GridRow({ columns: 5 }) {
        ForEach(this.list2, (item: string) => {
          GridCol() {
            Image(item)
              .width('100%')
              .borderRadius(4)
          }
          .margin({
            top: 10
          })
        })
      }
      GridRow({ columns: 5 }) {
        ForEach(this.list3, (item: string) => {
          GridCol() {
            Video({
              src: item
            })
              .width('100%')
              .aspectRatio(1)
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