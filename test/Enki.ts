import { loadFixture } from "@nomicfoundation/hardhat-toolbox/network-helpers"
import { expect } from "chai"
import { ethers } from "hardhat"

describe("Enki", function () {
    async function deployEnkiFixture() {
        const [owner, otherAccount] = await ethers.getSigners()

        const Enki = await ethers.getContractFactory("Enki")
        const enki = await Enki.deploy(
            owner.address,
            "Initial Text",
            "Initial CID"
        )

        return { enki, owner, otherAccount }
    }

    describe("Deployment", function () {
        it("Should set the right owner", async function () {
            const { enki, owner } = await loadFixture(deployEnkiFixture)
            expect(await enki.owner()).to.equal(owner.address)
        })

        it("Should set the initial text and CID", async function () {
            const { enki } = await loadFixture(deployEnkiFixture)
            expect(await enki.text()).to.equal("Initial Text")
            expect(await enki.cid()).to.equal("Initial CID")
        })
    })

    describe("Read", function () {
        it("Should return the current text", async function () {
            const { enki } = await loadFixture(deployEnkiFixture)
            expect(await enki.read()).to.equal("Initial Text")
        })
    })

    describe("Write", function () {
        it("Should update text and CID when called by owner", async function () {
            const { enki, owner } = await loadFixture(deployEnkiFixture)
            await expect(enki.connect(owner).write("New Text", "New CID"))
                .to.emit(enki, "Updated")
                .withArgs("New Text", "New CID")

            expect(await enki.text()).to.equal("New Text")
            expect(await enki.cid()).to.equal("New CID")
        })

        it("Should revert when called by non-owner", async function () {
            const { enki, otherAccount } = await loadFixture(deployEnkiFixture)
            await expect(
                enki.connect(otherAccount).write("New Text", "New CID")
            )
                .to.be.revertedWithCustomError(
                    enki,
                    "OwnableUnauthorizedAccount"
                )
                .withArgs(otherAccount.address)
        })
    })

    describe("Verify", function () {
        it("Should return true for matching text", async function () {
            const { enki } = await loadFixture(deployEnkiFixture)
            expect(await enki.verify("Initial Text")).to.be.true
        })

        it("Should return false for non-matching text", async function () {
            const { enki } = await loadFixture(deployEnkiFixture)
            expect(await enki.verify("Wrong Text")).to.be.false
        })
    })
})
